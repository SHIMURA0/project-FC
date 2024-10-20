//
//  AchievementsView.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//


//import SwiftUI
//
//struct Achievement: Identifiable {
//    let id = UUID()
//    let name: String
//    let description: String
//    let iconName: String
//    var isUnlocked: Bool
//    let rarity: AchievementRarity
//}
//
//enum AchievementRarity: String {
//    case bronze = "铜牌"
//    case silver = "银牌"
//    case gold = "金牌"
//    case platinum = "白金"
//    
//    var color: Color {
//        switch self {
//        case .bronze: return Color(red: 0.8, green: 0.5, blue: 0.2)
//        case .silver: return Color(white: 0.75)
//        case .gold: return Color(red: 1.0, green: 0.84, blue: 0.0)
//        case .platinum: return Color(red: 0.90, green: 0.89, blue: 0.89)
//        }
//    }
//    
//    var icon: String {
//        switch self {
//        case .bronze: return "🥉"
//        case .silver: return "🥈"
//        case .gold: return "🥇"
//        case .platinum: return "🏆"
//        }
//    }
//}
//
//struct AchievementsView: View {
//    @State private var achievements: [Achievement] = [
//        Achievement(name: "初学者", description: "完成你的第一场比赛", iconName: "star.fill", isUnlocked: true, rarity: .bronze),
//        Achievement(name: "连续答对", description: "在一场比赛中连续答对10题", iconName: "bolt.fill", isUnlocked: false, rarity: .silver),
//        Achievement(name: "速战速决", description: "在30秒内完成一局", iconName: "timer", isUnlocked: false, rarity: .gold),
//        Achievement(name: "完美胜利", description: "在一场比赛中答对所有问题", iconName: "crown.fill", isUnlocked: false, rarity: .platinum),
//        Achievement(name: "常胜将军", description: "连续赢得10场比赛", iconName: "trophy.fill", isUnlocked: false, rarity: .gold)
//    ]
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    TrophyCaseView(achievements: achievements)
//                    
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                        ForEach(achievements) { achievement in
//                            AchievementCard(achievement: achievement)
//                        }
//                    }
//                    .padding()
//                }
//            }
//            .navigationTitle("个人成就")
//            .background(Color.white.edgesIgnoringSafeArea(.all))
//        }
//    }
//}
//
//struct TrophyCaseView: View {
//    let achievements: [Achievement]
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 20) {
//                ForEach(AchievementRarity.allCases, id: \.self) { rarity in
//                    VStack {
//                        Text(rarity.icon)
//                            .font(.system(size: 50))
//                        Text("\(achievementCount(for: rarity))")
//                            .font(.headline)
//                        Text(rarity.rawValue)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .frame(width: 80, height: 100)
//                    .background(rarity.color.opacity(0.1))
//                    .cornerRadius(10)
//                }
//            }
//            .padding()
//        }
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(15)
//        .padding()
//    }
//    
//    func achievementCount(for rarity: AchievementRarity) -> Int {
//        achievements.filter { $0.rarity == rarity && $0.isUnlocked }.count
//    }
//}
//
//struct AchievementCard: View {
//    let achievement: Achievement
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                Circle()
//                    .fill(achievement.rarity.color.opacity(0.3))
//                    .frame(width: 60, height: 60)
//                
//                Image(systemName: achievement.iconName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(achievement.isUnlocked ? achievement.rarity.color : .gray)
//            }
//            .overlay(
//                Circle()
//                    .stroke(achievement.isUnlocked ? achievement.rarity.color : Color.gray, lineWidth: 2)
//            )
//            
//            Text(achievement.name)
//                .font(.headline)
//                .fontWeight(.bold)
//                .foregroundColor(.black)
//                .multilineTextAlignment(.center)
//            
//            Text(achievement.description)
//                .font(.caption)
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
//            
//            Text(achievement.rarity.rawValue)
//                .font(.caption2)
//                .foregroundColor(achievement.rarity.color)
//                .padding(.horizontal, 8)
//                .padding(.vertical, 4)
//                .background(achievement.rarity.color.opacity(0.2))
//                .cornerRadius(10)
//        }
//        .frame(width: 150, height: 180)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(20)
//        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(achievement.isUnlocked ? achievement.rarity.color : Color.gray.opacity(0.5), lineWidth: 2)
//        )
//    }
//}
//
//extension AchievementRarity: CaseIterable {}
//
//struct AchievementsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AchievementsView()
//    }
//}


import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    var description: String
    let iconName: String
    var isUnlocked: Bool
    var rarity: AchievementRarity
    var unlockedDate: Date?
    var unlockCondition: String
    var progress: Double // 0.0 to 1.0
    var level: Int = 1
    var timesAchieved: Int = 0
    var rankAmongPlayers: Int?
    var nextLevelRequirement: String?
}

enum AchievementRarity: String, CaseIterable {
    case bronze = "铜牌"
    case silver = "银牌"
    case gold = "金牌"
    case platinum = "白金"
    
    var color: Color {
        switch self {
        case .bronze: return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .silver: return Color(white: 0.75)
        case .gold: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .platinum: return Color(red: 0.90, green: 0.89, blue: 0.89)
        }
    }
    
    var icon: String {
        switch self {
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        case .platinum: return "🏆"
        }
    }
}

struct AchievementsView: View {
    @State private var achievements: [Achievement] = [
        Achievement(name: "初学者", description: "完成你的第一场比赛", iconName: "star.fill", isUnlocked: true, rarity: .bronze, unlockedDate: Date(), unlockCondition: "完成第一场比赛", progress: 1.0),
        Achievement(name: "连续答对", description: "在一场比赛中连续答对10题", iconName: "bolt.fill", isUnlocked: false, rarity: .silver, unlockedDate: nil, unlockCondition: "在一场比赛中连续答对10题", progress: 0.5),
        Achievement(name: "速战速决", description: "在30秒内完成一局", iconName: "timer", isUnlocked: false, rarity: .gold, unlockedDate: nil, unlockCondition: "在30秒内完成一局", progress: 0.0),
        Achievement(name: "完美胜利", description: "在一场比赛中答对所有问题", iconName: "crown.fill", isUnlocked: false, rarity: .platinum, unlockedDate: nil, unlockCondition: "在一场比赛中答对所有问题", progress: 0.8),
        Achievement(
            name: "常胜将军",
            description: "连续赢得10场比赛",
            iconName: "trophy.fill",
            isUnlocked: false,
            rarity: .gold,
            unlockedDate: nil,
            unlockCondition: "连续赢得10场比赛",
            progress: 0.3,
            nextLevelRequirement: "连续赢得20场比赛"
        ),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TrophyCaseView(achievements: achievements)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(achievements) { achievement in
                            NavigationLink(destination: AchievementDetailView(achievement: achievement)) {
                                AchievementCard(achievement: achievement)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("个人成就")
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

struct TrophyCaseView: View {
    let achievements: [Achievement]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(AchievementRarity.allCases, id: \.self) { rarity in
                    VStack {
                        Text(rarity.icon)
                            .font(.system(size: 50))
                        Text("\(achievementCount(for: rarity))")
                            .font(.headline)
                        Text(rarity.rawValue)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 80, height: 100)
                    .background(rarity.color.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding()
    }
    
    func achievementCount(for rarity: AchievementRarity) -> Int {
        achievements.filter { $0.rarity == rarity && $0.isUnlocked }.count
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(achievement.rarity.color.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(achievement.isUnlocked ? achievement.rarity.color : .gray)
            }
            .overlay(
                Circle()
                    .stroke(achievement.isUnlocked ? achievement.rarity.color : Color.gray, lineWidth: 2)
            )
            
            Text(achievement.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            if !achievement.isUnlocked {
                ProgressView(value: achievement.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: achievement.rarity.color))
                    .frame(height: 5)
            }
            
            Text(achievement.rarity.rawValue)
                .font(.caption2)
                .foregroundColor(achievement.rarity.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(achievement.rarity.color.opacity(0.2))
                .cornerRadius(10)
        }
        .frame(width: 150, height: 180)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(achievement.isUnlocked ? achievement.rarity.color : Color.gray.opacity(0.5), lineWidth: 2)
        )
    }
}

struct AchievementDetailView: View {
    let achievement: Achievement
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 图标和名称
                VStack {
                    Image(systemName: achievement.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(achievement.rarity.color)
                        .padding()
                        .background(
                            Circle()
                                .fill(achievement.rarity.color.opacity(0.2))
                        )
                    
                    Text(achievement.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Level \(achievement.level)")
                        .font(.subheadline)
                        .foregroundColor(achievement.rarity.color)
                }
                
                // 描述
                Text(achievement.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // 稀有度
                HStack {
                    Text("稀有度:")
                    Text(achievement.rarity.rawValue)
                        .foregroundColor(achievement.rarity.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(achievement.rarity.color.opacity(0.2))
                        .cornerRadius(10)
                }
                
                // 解锁条件
                VStack(alignment: .leading) {
                    Text("当前解锁条件:")
                        .font(.headline)
                    Text(achievement.unlockCondition)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // 进度或解锁时间
                if achievement.isUnlocked {
                    VStack(alignment: .leading) {
                        Text("解锁时间:")
                            .font(.headline)
                        Text(formattedDate(achievement.unlockedDate))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                } else {
                    VStack(alignment: .leading) {
                        Text("当前进度:")
                            .font(.headline)
                        ProgressView(value: achievement.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: achievement.rarity.color))
                        Text("\(Int(achievement.progress * 100))%")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // 额外信息
                VStack(alignment: .leading, spacing: 10) {
                    Text("额外信息:")
                        .font(.headline)
                    Text("已获得次数: \(achievement.timesAchieved)")
                    if let rank = achievement.rankAmongPlayers {
                        Text("获得排名: 第\(rank)位")
                    }
                    if let nextLevel = achievement.nextLevelRequirement {
                        Text("下一级要求: \(nextLevel)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("成就详情")
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "未解锁" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
