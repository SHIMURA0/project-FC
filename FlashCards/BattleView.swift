//
//  BattleView.swift
//  FlashCards
//
//  Created by Shimura on 2024/10/20.
//

import SwiftUI

struct Question {
    let text: String
    var options: [String]  // 改为 var
    let correctAnswer: String
}

struct BattleView: View {
    @State private var currentQuestionIndex = 0
    @State private var playerScore = 0
    @State private var opponentScore = 0
    @State private var timeRemaining = 60
    @State private var showResult = false
    @State private var energy: Double = 0
    @State private var showPowerUpOptions = false
    @State private var comboCount = 0
    @State private var doubleScoreActive = false
    @State private var questions: [Question]  // 改为 State 变量
    
    init() {
        // 在初始化器中设置问题
        _questions = State(initialValue: [
            Question(text: "1 + 1 = ?", options: ["2", "3", "4", "5"], correctAnswer: "2"),
            Question(text: "2 + 2 = ?", options: ["3", "4", "5", "6"], correctAnswer: "4"),
            Question(text: "3 + 3 = ?", options: ["5", "6", "7", "8"], correctAnswer: "6"),
            Question(text: "4 + 4 = ?", options: ["6", "7", "8", "9"], correctAnswer: "8"),
            Question(text: "5 + 5 = ?", options: ["8", "9", "10", "11"], correctAnswer: "10"),
        ])
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    PlayerInfoView(name: "You", score: playerScore, color: .blue)
                    Spacer()
                    PlayerInfoView(name: "Opponent", score: opponentScore, color: .red)
                }
                .padding()
                
                ProgressView(value: Double(currentQuestionIndex), total: Double(questions.count))
                    .accentColor(.white)
                    .padding()
                
                TimeRemainingView(timeRemaining: $timeRemaining)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            showResult = true
                        }
                    }
                
                EnergyBarView(energy: $energy)
                    .padding()
                
                if currentQuestionIndex < questions.count {
                    QuestionView(question: questions[currentQuestionIndex], onAnswer: checkAnswer)
                } else {
                    Text("所有问题已回答完毕！")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }
                
                if energy >= 100 {
                    Button("使用特殊能力") {
                        showPowerUpOptions = true
                    }
                    .buttonStyle(PowerUpButtonStyle())
                }
                
                Text("连击: \(comboCount)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if doubleScoreActive {
                    Text("双倍分数已激活!")
                        .font(.headline)
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            
            if showPowerUpOptions {
                PowerUpOptionsView(onSelect: usePowerUp)
            }
            
            if showResult {
                ResultView(playerScore: playerScore, opponentScore: opponentScore)
            }
        }
    }
    
    func checkAnswer(_ answer: String) {
        let currentQuestion = questions[currentQuestionIndex]
        if answer == currentQuestion.correctAnswer {
            let baseScore = 10
            let comboBonus = comboCount * 2
            let scoreMultiplier = doubleScoreActive ? 2 : 1
            let totalScore = (baseScore + comboBonus) * scoreMultiplier
            
            playerScore += totalScore
            energy = min(energy + 20, 100)
            comboCount += 1
        } else {
            comboCount = 0
        }
        
        if Bool.random() {
            opponentScore += 10
        }
        
        currentQuestionIndex += 1
        if currentQuestionIndex >= questions.count {
            showResult = true
        }
        
        if doubleScoreActive {
            doubleScoreActive = false
        }
    }
    
    func usePowerUp(_ powerUp: PowerUp) {
        switch powerUp {
        case .timeFreeze:
            timeRemaining += 10
        case .fiftyFifty:
            if currentQuestionIndex < questions.count {
                let correctAnswer = questions[currentQuestionIndex].correctAnswer
                var newOptions = [correctAnswer]
                let wrongOptions = questions[currentQuestionIndex].options.filter { $0 != correctAnswer }
                newOptions.append(wrongOptions.randomElement()!)
                questions[currentQuestionIndex].options = newOptions.shuffled()
            }
        case .doubleScore:
            doubleScoreActive = true
        }
        energy = 0
        showPowerUpOptions = false
    }
}

struct PlayerInfoView: View {
    let name: String
    let score: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(score)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}

struct TimeRemainingView: View {
    @Binding var timeRemaining: Int
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(.white)
            Text("\(timeRemaining)s")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
}

struct EnergyBarView: View {
    @Binding var energy: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Rectangle()
                    .frame(width: min(CGFloat(self.energy / 100.0) * geometry.size.width, geometry.size.width), height: 20)
                    .foregroundColor(.yellow)
                    .animation(.linear, value: energy)
            }
            .cornerRadius(45)
        }
        .frame(height: 20)
    }
}

struct QuestionView: View {
    let question: Question
    let onAnswer: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(question.text)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
            
            ForEach(question.options, id: \.self) { option in
                Button(action: {
                    onAnswer(option)
                }) {
                    Text(option)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }
    }
}

struct ResultView: View {
    let playerScore: Int
    let opponentScore: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("游戏结束！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("您的得分: \(playerScore)")
                .font(.title2)
                .foregroundColor(.white)
            
            Text("对手得分: \(opponentScore)")
                .font(.title2)
                .foregroundColor(.white)
            
            ResultMessageView(playerScore: playerScore, opponentScore: opponentScore)
        }
        .padding(40)
        .background(Color.black.opacity(0.7))
        .cornerRadius(30)
        .shadow(radius: 20)
    }
}

struct ResultMessageView: View {
    let playerScore: Int
    let opponentScore: Int
    
    var body: some View {
        Group {
            if playerScore > opponentScore {
                Text("恭喜您获胜！")
                    .foregroundColor(.green)
            } else if playerScore < opponentScore {
                Text("很遗憾，您输了。")
                    .foregroundColor(.red)
            } else {
                Text("平局！")
                    .foregroundColor(.yellow)
            }
        }
        .font(.title)
        .fontWeight(.bold)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct PowerUpButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

enum PowerUp {
    case timeFreeze, fiftyFifty, doubleScore
}

struct PowerUpOptionsView: View {
    let onSelect: (PowerUp) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Button("时间冻结") { onSelect(.timeFreeze) }
            Button("50/50") { onSelect(.fiftyFifty) }
            Button("双倍分数") { onSelect(.doubleScore) }
        }
        .buttonStyle(PowerUpButtonStyle())
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
    }
}

struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        BattleView()
    }
}


#Preview {
    BattleView()
}

