//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Lorenzo Ilardi on 08/04/25.
//

import SwiftUI

struct HomeGameView: View {
    @State private var gameState: ViewState = .starting
    @State private var playerName: String = ""
    @State private var playerWonRound: Bool = false
    @State private var botChoice: GameStateElement?
    @State private var playerChoice: GameStateElement?
    @State private var botScore: Int = 0
    @State private var playerScore: Int = 0
    @State private var roundNumber: Int = 1
    @State private var shouldShowAlert: Bool = false
    
    private let maxNumberOfRounds: Int = 10
    private let gameElementsArray: [GameStateElement] = [.rock, .paper, .scissors]
    
    private var alertDescription: String {
        if playerScore < botScore {
            return "Bot Won 😳"
        } else if playerScore > botScore {
            return "You Won! ✌️"
        } else {
            return "It's a tie!"
        }
    }
    
    var body: some View {
        switch gameState {
        case .starting:
            startingStateScreen
        case .playing:
            playingStateScreen
                .alert(
                    alertDescription,
                    isPresented: $shouldShowAlert) {
                        Button("Restart", action: restartGame)
                    }
        default:
            Text(playerName + " playing")
        }
    }
    
    //MARK: - Methods
    private func userDidChoose(_ choice: GameStateElement) {
        playerChoice = choice
        botChoice = gameElementsArray.randomElement()!
        calculateWinner()
        goToNextRound()
    }
    
    private func calculateWinner() {
        guard
            let playerChoice,
            let botChoice,
            let playerWonRound = playerChoice >> botChoice
        else {
            return
        }
        
        self.playerWonRound = playerWonRound
        calculateScore()
    }
    
    private func calculateScore() {
        if playerWonRound {
            playerScore += 1
        } else {
            botScore += 1
        }
    }
    
    private func goToNextRound() {
        if roundNumber + 1 <= maxNumberOfRounds {
            roundNumber += 1
        } else {
            shouldShowAlert = true
        }
    }
    
    private func restartGame() {
        playerScore = 0
        botScore = 0
        botChoice = nil
        playerChoice = nil
        roundNumber = 1
        playerWonRound = false
    }
}

//MARK: - UI components extension
private extension HomeGameView {
    var startingStateScreen: some View {
        ZStack {
            backgroundGradient
            
            VStack(alignment: .center, spacing: 200) {
                VStack(spacing: 100) {
                    HStack {
                        Rectangle()
                            .frame(width: 1)
                        VStack(alignment: .leading) {
                            Text("Rock")
                            Text("Paper")
                            Text("Scissors")
                        }
                        .font(.largeTitle)
                    }
                    .frame(width: 300, height: 110)
                    .foregroundStyle(.primary)
                    
                    
                    VStack {
                        Text("What's your name?")
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        TextField("Enter your name...", text: $playerName)
                            .frame(width: 200, height: 50)
                            .background(.thinMaterial)
                            .multilineTextAlignment(.center)
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(radius: 5, x: 5, y: 5)
                    }
                }
                
                Button {
                    gameState = .playing
                } label: {
                    Text("Play")
                    Image(systemName: "restart")
                }
                .disabled(playerName.isEmpty)
                .frame(width: 100, height: 50)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 5, x: 3, y: 3)
                .foregroundStyle(.primary)
                .font(.system(size: 17, weight: .semibold, design: .monospaced))
            }
            .padding(.vertical, 20)
        }
    }
    
    var playingStateScreen: some View {
        ZStack {
            backgroundGradient
            VStack() {
                HStack {
                    Text("🤖")
                        .font(.system(size: 60))
                    Spacer()
                    Text("\(botScore)")
                        .font(.system(size: 30, weight: .semibold, design: .monospaced))
                }
                
                Spacer()
                
                VStack(spacing: 60) {
                    HStack(spacing: 20) {
                        ForEach(gameElementsArray, id: \.self) { gameElement in
                            SquareCustomButton(
                                managedGameElement: gameElement,
                                isSelected: gameElement == botChoice,
                                isTappable: false,
                                action: nil)
                            .shadow(radius: 5, x: 0, y: -5)
                        }
                    }
                    
                    Divider()
                        .background(.primary)
                    
                    centerBoardView
                    
                    Divider()
                        .background(.primary)
                    
                    HStack(spacing: 20) {
                        ForEach(gameElementsArray, id: \.self) { gameElement in
                            SquareCustomButton(
                                managedGameElement: gameElement,
                                isSelected: gameElement == playerChoice,
                                isTappable: true) { userChoice in
                                    guard let userChoice else { return }
                                    userDidChoose(userChoice)
                                }
                                .shadow(radius: 5, x: 0, y: 5)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    HStack {
                        Text(playerName)
                            .font(.system(size: 40, weight: .semibold, design: .monospaced))
                        Spacer()
                        Text("\(playerScore)")
                            .font(.system(size: 30, weight: .semibold, design: .monospaced))
                    }
                    
                    Text("Round \(roundNumber)/\(maxNumberOfRounds)")
                        .font(.system(size: 20, weight: .thin, design: .monospaced))
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var centerBoardView: some View {
        HStack {
            HStack {
                if playerChoice != nil {
                    Text("You")
                    Spacer()
                }
                Text(playerChoice?.description ?? "Your move")
            }
            Text("/")
                .font(.system(size: 20, weight: .semibold))
            HStack {
                Text(botChoice?.description ?? "Its move")
                if botChoice != nil {
                    Spacer()
                    Text("Bot")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .font(.system(size: 30, weight: .thin, design: .monospaced))
    }
    
    private var backgroundGradient: some View {
        RadialGradient(
            gradient: Gradient(colors: [Color.green.opacity(0.5), Color.mint]),
            center: .center,
            startRadius: 20,
            endRadius: 400
        ).ignoresSafeArea(.all)
    }
}

//MARK: - Inner logic components extension
private extension HomeGameView {
    enum ViewState {
        case starting
        case playing
        case scoreboard
    }
}

#Preview("HomeView") {
    HomeGameView()
}
