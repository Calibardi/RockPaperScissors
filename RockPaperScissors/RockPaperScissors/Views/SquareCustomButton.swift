//
//  SquareCustomButton.swift
//  RockPaperScissors
//
//  Created by Lorenzo Ilardi on 08/04/25.
//

import SwiftUI

struct SquareCustomButton: View {
    let managedGameElement: GameStateElement
    let isSelected: Bool
    let isTappable: Bool
    let action: ((GameStateElement?) -> Void)?
    
    
    var body: some View {
        Button {
            action?(managedGameElement)
        } label: {
            Text(managedGameElement.description)
                .font(.system(size: 65))
        }
        .buttonStyle(.plain)
        .frame(width: 100, height: 100)
        .background(.thinMaterial)
        .clipShape(.circle)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(isSelected ? Color.primary: Color.clear, lineWidth: 1)
        )
        .allowsHitTesting(isTappable)
    }
}

#Preview {
    SquareCustomButton(managedGameElement: .rock, isSelected: true, isTappable: false) { _ in
        print("tapped")
    }
}
