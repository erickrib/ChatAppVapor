//
//  UserInfo.swift
//  ChatApp
//
//  Created by Erick Ribeiro on 16/08/23.
//

import Foundation

class UserInfo: ObservableObject {
    let userID = UUID()
    @Published var username = ""
}
