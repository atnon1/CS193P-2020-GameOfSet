//
//  GameOfSetView.swift
//  Shared
//
//  Created by Anton Makeev on 16.12.2020.
//

import SwiftUI

struct GameOfSetView: View {
    @ObservedObject var gameProvider : SetGameProvider
    
    var body: some View {
        GeometryReader { geometry in
            Grid(gameProvider.cardsOnTable) { card in
                SetCardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding()
            }
        }
    }
}


struct SetCardView: View {
    var color: Color {
        switch card.color {
        case .purple: return Color.purple
        case .green: return Color.green
        case .red: return Color.red
        }
    }
    var opacityLevel: Double {
        switch card.shading {
        case .open: return openOppacity
        case .solid: return solidOpacity
        case .striped: return strippedOpacity
        }
    }
    
    var card: SetCard

    var body: some View {
        print(card)
        return VStack {
           ForEach(Range(1...card.number)) { _ in
            ZStack{
                switch card.symbol {
                case .oval:
                    Capsule().fill()
                        .opacity(opacityLevel)
                    Capsule().stroke(lineWidth: symbolStrokeWidth)
                case .diamond:
                    Rectangle().fill()
                        .opacity(opacityLevel)
                    Rectangle().stroke(lineWidth: symbolStrokeWidth)
                case .squiggle:
                    Ellipse().fill()
                        .opacity(opacityLevel)
                    Ellipse().stroke(lineWidth: symbolStrokeWidth)
                }
            }
            .padding(.vertical, 2)
            .aspectRatio(2/1, contentMode: .fit)
            }
           .foregroundColor(self.color)
        }
        .padding()
        .cardify(isFaceUp: card.isFaceUp)
    }
    
    // MARK: - Drawing constants
    let symbolStrokeWidth: CGFloat = 3.0
    let solidOpacity: Double = 1
    let strippedOpacity: Double = 0.3
    let openOppacity: Double = 0
    
    
    
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameOfSetView(gameProvider: SetGameProvider())
    }
}

