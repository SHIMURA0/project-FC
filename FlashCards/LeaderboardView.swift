//
//  LeaderboardView.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//


import SwiftUI

//struct LeaderboardView: View {
//    @StateObject private var viewModel = LeaderboardViewModel()
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                if viewModel.players.isEmpty {
//                    Text("暂无排行数据")
//                        .font(.headline)
//                        .padding()
//                } else {
//                    VStack(spacing: 20) {
//                        PodiumView(topPlayers: Array(viewModel.players.prefix(3)))
//                        
//                        ForEach(viewModel.players.dropFirst(3)) { player in
//                            PlayerRankRow(player: player)
//                        }
//                    }
//                    .padding()
//                }
//            }
//            .navigationTitle("排行榜")
//            .onAppear {
//                viewModel.fetchLeaderboard()
//            }
//        }
//    }
//}

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.players.isEmpty {
                            Text("暂无排行数据")
                                .font(.headline)
                                .padding()
                        } else {
                            PodiumView(topPlayers: Array(viewModel.players.prefix(3)))
                                .padding(.top)
                            
                            ForEach(viewModel.players.dropFirst(3)) { player in
                                PlayerRankRow(player: player)
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await refreshData()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
//                        Image(systemName: "trophy.fill")
//                            .foregroundColor(.yellow)
                        Text("排行榜")
                            .font(.headline)
                            .foregroundColor(.primary)
//                        Image(systemName: "trophy.fill")
//                            .foregroundColor(.yellow)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await refreshData()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchLeaderboard()
        }
    }
    
    func refreshData() async {
        isRefreshing = true
        viewModel.refreshLeaderboard()
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        isRefreshing = false
    }
}


struct MedalView: View {
    let place: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(medalColor, lineWidth: 6)
                .frame(width: 80, height: 80)
            
            Image(systemName: "medal.fill")
                .foregroundColor(medalColor)
                .font(.system(size: 20))
                .offset(y: -60)
        }
    }
    
    var medalColor: Color {
        switch place {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
}

//struct MedalView: View {
//    let place: Int
//    
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(medalColor)
//                .frame(width: 30, height: 30)
//                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
//            
//            Text("\(place)")
//                .foregroundColor(.white)
//                .font(.system(size: 16, weight: .bold))
//        }
//    }
//    
//    var medalColor: Color {
//        switch place {
//        case 1: return .yellow
//        case 2: return .gray
//        case 3: return .orange
//        default: return .blue
//        }
//    }
//}





//struct PodiumView: View {
//    let topPlayers: [RankingPlayer]
//    
//    var body: some View {
//        HStack(alignment: .bottom, spacing: 0) {
//            PodiumPlayerView(player: topPlayers.count > 1 ? topPlayers[1]: placeholderPlayer(rank: 2), place: 2, offset: 40)
//            PodiumPlayerView(player: topPlayers.count > 0 ? topPlayers[0]: placeholderPlayer(rank: 1), place: 1, offset: 0)
//            PodiumPlayerView(player: topPlayers.count > 2 ? topPlayers[2]: placeholderPlayer(rank: 3), place: 3, offset: 60)
//        }
//        .frame(height: 280)
//    }
//    
//    private func placeholderPlayer(rank: Int) -> RankingPlayer {
//        RankingPlayer(rank: rank, name: "未知", avatarName: "person.circle.fill", school: "未知", score: 0)
//    }
//}

struct PodiumView: View {
    let topPlayers: [RankingPlayer]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            PodiumPlayerView(player: topPlayers.count > 1 ? topPlayers[1]: placeholderPlayer(rank: 2), place: 2, offset: 40)
            PodiumPlayerView(player: topPlayers.count > 0 ? topPlayers[0]: placeholderPlayer(rank: 1), place: 1, offset: 0)
            PodiumPlayerView(player: topPlayers.count > 2 ? topPlayers[2]: placeholderPlayer(rank: 3), place: 3, offset: 60)
        }
        .frame(height: 300)
        .padding(.bottom)
    }
    
    private func placeholderPlayer(rank: Int) -> RankingPlayer {
        RankingPlayer(rank: rank, name: "未知", avatarName: "person.circle.fill", school: "未知", score: 0)
    }
}




//struct PodiumPlayerView: View {
//    let player: RankingPlayer
//    let place: Int
//    let offset: CGFloat
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                Image(systemName: player.avatarName)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 60, height: 60)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.gold, lineWidth: 2))
//                
//                Image(systemName: trophyImageName)
//                    .foregroundColor(trophyColor)
//                    .font(.system(size: 24))
//                    .offset(x: 25, y: -25)
//            }
//            
//            Text(player.name)
//                .font(.caption)
//                .fontWeight(.bold)
//            
//            Text("\(player.score)")
//                .font(.caption2)
//            
//            ZStack {
//                Rectangle()
//                    .fill(podiumColor)
//                    .frame(width: 80, height: 180 - offset)
//                
//                Text("#\(place)")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//            }
//        }
//    }
//    
//    var podiumColor: Color {
//        switch place {
//        case 1: return .gold
//        case 2: return .silver
//        case 3: return .bronze
//        default: return .gray
//        }
//    }
//    
//    var trophyImageName: String {
//        switch place {
//        case 1: return "trophy.fill"
//        case 2: return "medal.fill"
//        case 3: return "medal.fill"
//        default: return ""
//        }
//    }
//    
//    var trophyColor: Color {
//        switch place {
//        case 1: return .yellow
//        case 2: return .gray
//        case 3: return .orange
//        default: return .clear
//        }
//    }
//}

struct PodiumPlayerView: View {
    let player: RankingPlayer
    let place: Int
    let offset: CGFloat
    
    var body: some View {
        VStack {
            ZStack {
                MedalView(place: place)
                
                Image(systemName: player.avatarName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            
            Text(player.name)
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text("\(player.score)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Podium(height: 180 - offset, color: podiumColor, place: place)
        }
    }
    
    var podiumColor: Color {
        switch place {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
}

struct Podium: View {
    let height: CGFloat
    let color: Color
    let place: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 80, height: height)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            Text("#\(place)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}


struct PlayerRankRow: View {
    let player: RankingPlayer
    
    var body: some View {
        HStack {
            Text("#\(player.rank)")
                .font(.headline)
                .frame(width: 40)
            
            Image(systemName: player.avatarName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.headline)
                Text(player.school)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(player.score)")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

extension Color {
    static let gold = Color(red: 1, green: 0.84, blue: 0)
    static let silver = Color(white: 0.75)
    static let bronze = Color(red: 0.8, green: 0.5, blue: 0.2)
}


struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}

