//
//  SetGame.swift
//  Game of SET
//
//  Created by Anton Makeev on 16.12.2020.
//

import Foundation

struct SetGame {
    var deck: [SetCard]
    var openCards: [SetCard]

    init() {
        deck = []
        for symbol in SetCard.SetSymbol.allCases {
            for shading in SetCard.SetShading.allCases {
                for color in SetCard.SetColor.allCases  {
                    for number in (1...symbolMaxNumber) {
                        deck.append(SetCard(symbol: symbol, shading: shading, color: color, number: number, id: deck.count))
                    }
                }
            }
        }
        deck.shuffle()
        openCards = Array(deck[..<spaceOnTable]).map{
            var card = $0
            card.isFaceUp = true
            return card
        }
        deck.removeSubrange(..<spaceOnTable)
    }
    
    // MARK: Constants
    let symbolMaxNumber = 3
    let spaceOnTable = 12
}

struct SetCard: Identifiable {
    let symbol: SetSymbol
    let shading: SetShading
    let color: SetColor
    let number: Int
    var isFaceUp: Bool = false
    
    var id: Int
    
    enum SetSymbol: CaseIterable {
        case diamond
        case squiggle
        case oval
    }
    
    enum SetShading: CaseIterable {
        case solid
        case striped
        case open
    }
    
    enum SetColor: CaseIterable {
        case purple
        case red
        case green
    }
    
    
}
