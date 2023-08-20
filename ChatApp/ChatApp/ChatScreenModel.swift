//
//  ChatScreenModel.swift
//  ChatApp
//
//  Created by Erick Ribeiro on 16/08/23.
//

import Foundation

final class ChatScreenModel: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    
    private var username: String?
    private var userID: UUID?
    @Published private(set) var messages: [ReceivingChatMessage] = []
    
    // MARK: - Connection
    func connect(username: String, userID: UUID) {
        self.username = username
        self.userID = userID
        
        let url = URL(string: "ws://localhost:8080/chat")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume() // 6
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil) 
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)

        if case .success(let message) = incoming {
            onMessage(message: message)
        }
        else if case .failure(let error) = incoming {
            print("Error", error)
        }
    }

    private func onMessage(message: URLSessionWebSocketTask.Message) {
        if case .string(let text) = message {
            guard let data = text.data(using: .utf8),
                    let chatMessage = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data)
            else {
                return
            }

            DispatchQueue.main.async {
                self.messages.append(chatMessage)
            }
        }
    }
    
    deinit {
        disconnect()
    }
    
    func send(text: String) {
        guard let username = username, let userID = userID else {
            return
        }
        
        let message = SubmittedChatMessage(message: text, user: username, userID: userID)
        
        guard let json = try? JSONEncoder().encode(message),
                let jsonString = String(data: json, encoding: .utf8)
        else {
            return
        }
        
        webSocketTask?.send(.string(jsonString)) { error in
            if let error = error {
                print("Error sending message", error)
            }
        }
    }
}
