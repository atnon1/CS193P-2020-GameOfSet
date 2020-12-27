//
//  SetGameProvider.swift
//  Game of SET (iOS)
//
//  Created by Anton Makeev on 17.12.2020.
//

import SwiftUI

class SetGameProvider: ObservableObject {
    @Published private var game = SetGame()
    
    
    // MARK: - Acces to model
    var deck: [SetCard] {
        game.deck
    }
    
    var cardsOnTable: [SetCard] {
        game.openCards
    }
    
    
    // MARK: - Intents
    func startGame() {
        game.startGame()
    }
    
    func choose(card: SetCard) {
        game.choose(card)
    }
    
    func dealCards() {
        game.dealCards()
    }
}


