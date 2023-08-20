//
//  File.swift
//  
//
//  Created by Erick Ribeiro on 16/08/23.
//

import Foundation

struct SubmittedChatMessage: Decodable {
    let message: String
    let user: String 
    let userID: UUID
}

struct ReceivingChatMessage: Encodable, Identifiable { 
    let date = Date()
    let id = UUID()
    let message: String
    let user: String
    let userID: UUID
}
