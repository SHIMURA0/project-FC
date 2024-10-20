//
//  ContentView.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            BattleView()
        } else {
            LoginView(username: $username, password: $password, isLoggedIn: $isLoggedIn)
        }
    }
}

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            Text("知识竞赛登录")
                .font(.largeTitle)
                .padding()
            
            TextField("用户名", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // 这里应该添加实际的登录逻辑
                isLoggedIn = true
            }) {
                Text("登录")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
