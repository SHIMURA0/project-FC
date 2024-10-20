//
//  SearchingOpponentView.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//


import SwiftUI

struct SearchingOpponentView: View {
    @Binding var isSearching: Bool
    
    var body: some View {
        VStack {
            Text("正在搜索卧龙凤雏")
                .font(.title)
                .padding()
            
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            
            Text("请稍候...")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button("取消") {
                isSearching = false
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 20)
        }
    }
}

//#Preview{
//    SearchingOpponentView()
//}
