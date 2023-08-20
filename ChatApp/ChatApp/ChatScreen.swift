//
//  ChatScreen.swift
//  ChatApp
//
//  Created by Erick Ribeiro on 16/08/23.
//
import SwiftUI

struct ChatScreen: View {
    @StateObject private var model = ChatScreenModel()
    @EnvironmentObject private var userInfo: UserInfo
    
    @State private var message = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                        LazyVStack(spacing: 8) {
                            ForEach(model.messages) { message in
                                Text(message.user + " " + message.message)
                                    .id(message.id)
                            }
                        }
                        .onChange(of: model.messages.count) { _ in // 3
                            scrollToLastMessage(proxy: proxy)
                        }
                    }
            }
            
            HStack {
                TextField("Message", text: $message, onEditingChanged: { _ in }, onCommit: onCommit)                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5)
                
                Button(action: onCommit) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.system(size: 20))
                }
                .padding()
                .disabled(message.isEmpty)
            }
            .padding()
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
    
    private func onAppear() {
        model.connect(username: userInfo.username, userID: userInfo.userID)
    }
    
    private func onDisappear() {
        model.disconnect()
    }
    
    private func onCommit() {
        if !message.isEmpty {
            model.send(text: message)
            message = ""
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = model.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}
