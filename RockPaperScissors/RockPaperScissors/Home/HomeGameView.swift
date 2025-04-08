//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Lorenzo Ilardi on 08/04/25.
//

import SwiftUI

struct HomeGameView: View {
    @State private var playerName: String = ""
    @State private var gameState: ViewState = .playing
    @State private var playerWonRound: Bool = false
    @State private var playerWonMatch: Bool = false
    @State private var botChoice: GameStateElement?
    @State private var playerChoice: GameStateElement?
    @State private var botScore: Int = 0
    @State private var playerScore: Int = 0
    
    @State private var shouldShowAlert: Bool = false
    
    private let gameElementsArray: [GameStateElement] = [.rock, .paper, .scissors]
    
    var body: some View {
        switch gameState {
        case .starting:
            startingStateScreen
        case .playing:
            playingStateScreen
//                .alert(
//                    playerWonRound ? "You scored!": "Bot scored",
//                    isPresented: $shouldShowAlert) {
//                        Button("Next round", action: goToNextRound)
//                    }
        default:
            Text(playerName + " playing")
        }
    }
    
    //MARK: - Methods
    private func userDidChoose(_ choice: GameStateElement) {
        playerChoice = choice
        botChoice = gameElementsArray.randomElement()!
        calculateWinner()
        calculateScore()
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
    
//    private func goToNextRound() {
//        playerChoice = nil
//        botChoice = nil
//    }
}

//MARK: - UI components extension
private extension HomeGameView {
    var startingStateScreen: some View {
        VStack(alignment: .center, spacing: 50) {
            VStack {
                Text("Rock")
                Text("Paper")
                Text("Scissors")
            }
            .font(.largeTitle)
            
            VStack {
                Text("What's your name?")
                TextField("Enter your name...", text: $playerName)
                    .frame(width: 200, height: 50)
                    .background(.thinMaterial)
                    .multilineTextAlignment(.center)
                    .clipShape(.rect(cornerRadius: 10))
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
            .multilineTextAlignment(.center)
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding(.vertical, 20)
    }
    
    var playingStateScreen: some View {
        VStack(spacing: 50) {
            HStack {
                Text("🤖")
                Spacer()
                Text("Score: \(botScore)")
            }
            
            Spacer()
            VStack(spacing: 100) {
                HStack(spacing: 20) {
                    ForEach(gameElementsArray, id: \.self) { gameElement in
                        SquareCustomButton(
                            managedGameElement: gameElement,
                            isSelected: gameElement == botChoice,
                            isTappable: false,
                            action: nil)
                    }
                }
                
                HStack {
                    Text(playerChoice?.description ?? "Your move")
                    Text("/")
                        .font(.system(size: 20))
                    Text(botChoice?.description ?? "Its move")
                }.font(.system(size: 30))
                
                HStack(spacing: 20) {
                    ForEach(gameElementsArray, id: \.self) { gameElement in
                        SquareCustomButton(
                            managedGameElement: gameElement,
                            isSelected: gameElement == playerChoice,
                            isTappable: true) { userChoice in
                                guard let userChoice else { return }
                                userDidChoose(userChoice)
                            }
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Text(playerName)
                Spacer()
                Text("Score: \(playerScore)")
            }
            
            Text("Round 1/10")
        }
        .padding(.horizontal, 20)
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
