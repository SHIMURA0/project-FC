//
//  RankingPlayer.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//

import Foundation

struct RankingPlayer: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let avatarName: String
    let school: String
    let score: Int
}
