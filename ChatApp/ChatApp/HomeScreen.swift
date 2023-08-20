//
//  HomeScreen.swift
//  ChatApp
//
//  Created by Erick Ribeiro on 16/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var userInfo: UserInfo // 1
    
    private var isUsernameValid: Bool {
        !userInfo.username.trimmingCharacters(in: .whitespaces).isEmpty // 2
    }
    
    var body: some View {
        Form {
            Section(header: Text("Usuário")) {
                TextField("Nome", text: $userInfo.username) // 3

                NavigationLink("Continue", destination: ChatScreen()) // 4
                    .disabled(!isUsernameValid)
            }
        }
        .navigationTitle("Chat Teste")
    }
}
