//
//  ContentView.swift
//  ChatApp
//
//  Created by Erick Ribeiro on 16/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userInfo = UserInfo() // 1
    
    var body: some View {
        NavigationView {
            SettingsScreen()
        }
        .environmentObject(userInfo)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
