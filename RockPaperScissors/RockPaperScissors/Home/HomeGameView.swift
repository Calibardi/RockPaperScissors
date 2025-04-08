//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Lorenzo Ilardi on 08/04/25.
//

import SwiftUI

struct HomeGameView: View {
    @State private var playerName: String = ""
    @State private var gameState: ViewState = .starting
    
    var body: some View {
        switch gameState {
        case .starting:
            startingStateScreen
        default:
            Text(playerName + " playing")
        }
    }
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
