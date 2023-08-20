//
//  MessageModel.swift
//  ChatApp
//
//  Created by Erick Ribeiro on 16/08/23.
//

import Foundation

struct SubmittedChatMessage: Encodable {
    let message: String
    let user: String
        let userID: UUID
}

struct ReceivingChatMessage: Decodable, Identifiable {
    let date: Date
    let id: UUID
    let message: String
    let user: String
    let userID: UUID
}

