//
//  LeaderboardViewModel.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//

//import Foundation
//
//class LeaderboardViewModel: ObservableObject {
//    @Published var players: [RankingPlayer] = []
//    
//    func fetchLeaderboard() {
//        // 模拟从服务器获取数据
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.players = [
//                RankingPlayer(rank: 1, name: "Player1", avatarName: "person.crop.circle.fill", school: "School A", score: 1000),
//                RankingPlayer(rank: 2, name: "Player2", avatarName: "person.crop.circle.fill", school: "School B", score: 950),
//                RankingPlayer(rank: 3, name: "Player3", avatarName: "person.crop.circle.fill", school: "School C", score: 900),
//                RankingPlayer(rank: 4, name: "Player4", avatarName: "person.crop.circle.fill", school: "School D", score: 850),
//                RankingPlayer(rank: 5, name: "Player5", avatarName: "person.crop.circle.fill", school: "School E", score: 800),
//                // 添加更多玩家...
//            ]
//        }
//    }
//}


import Foundation

class LeaderboardViewModel: ObservableObject {
    @Published var players: [RankingPlayer] = []
    @Published var isLoading = false
    
    init() {
        fetchLeaderboard()
    }
    
    func fetchLeaderboard() {
        isLoading = true
        // 模拟加载延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.players = self.generateMockData()
            self.isLoading = false
        }
    }
    
    func refreshLeaderboard() {
        fetchLeaderboard()
    }
    
    private func generateMockData() -> [RankingPlayer] {
        let names = ["Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Henry", "Ivy", "Jack"]
        let schools = ["Harvard", "MIT", "Stanford", "Oxford", "Cambridge", "Yale", "Princeton", "Columbia", "Berkeley", "Caltech"]
        let avatars = ["person.crop.circle.fill", "person.crop.circle", "person.circle.fill", "person.circle", "person.fill"]
        
        return (1...100).map { rank in
            let name = names.randomElement()!
            let school = schools.randomElement()!
            let avatar = avatars.randomElement()!
            let score = Int.random(in: 500...1000)
            return RankingPlayer(rank: rank, name: name, avatarName: avatar, school: school, score: score)
        }.sorted { $0.score > $1.score }
    }
}

