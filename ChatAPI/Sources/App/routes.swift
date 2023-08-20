import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    var clientConnections = Set<WebSocket>()
    
    app.webSocket("chat") { req, client in
        clientConnections.insert(client)
        
        client.onClose.whenComplete { _ in
            clientConnections.remove(client)
        }
        
        client.onText { _, text in // 1
            do {
                guard let data = text.data(using: .utf8) else {
                    return
                }
                
                let incomingMessage = try JSONDecoder().decode(SubmittedChatMessage.self, from: data)
                
                let outgoingMessage = ReceivingChatMessage(
                    message: incomingMessage.message,
                    user: incomingMessage.user,
                    userID: incomingMessage.userID
                )
                
                let json = try JSONEncoder().encode(outgoingMessage) // 4
                
                guard let jsonString = String(data: json, encoding: .utf8) else {
                    return
                }
                
                print(jsonString)
                
                for connection in clientConnections {
                    connection.send(jsonString) // 5
                }
            }
            catch {
                print(error) // 6
            }
        }
    }
}

extension WebSocket: Hashable {
    public static func == (lhs: WebSocket, rhs: WebSocket) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
