//
//  GameStateElements.swift
//  RockPaperScissors
//
//  Created by Lorenzo Ilardi on 08/04/25.
//

enum GameStateElements {
    case rock
    case paper
    case scissors
    
    var description: String {
        switch self {
        case .rock:
            "🪨"
        case .paper:
            "📄"
        case .scissors:
            "✂️"
        }
    }
    
    /**
     Checks if the left-hand side choice wins against the right-hand side choice in a Rock-Paper-Scissors game.
     
     - Parameters:
     - lhs: The first choice (left-hand side).
     - rhs: The second choice (right-hand side).
     
     - Returns: `true` if `lhs` wins against `rhs`, `false` otherwise.
     */
    static func >> (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            return true
        default:
            return false
        }
    }
}
