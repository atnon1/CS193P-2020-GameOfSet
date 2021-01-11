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
    
    var score: (firstPlayer: Double, secondPlayer: Double) {
        let points = game.score.points
        return (points.firstPlayer, points.secondPlayer)
    }
    
    var cheatSet: (SetCard, SetCard, SetCard)? {
        game.firstOpenSet
    }
    
    func cheatSetContains(card: SetCard) -> Bool {
        if let cheatSet = cheatSet {
            return [cheatSet.0, cheatSet.1, cheatSet.2].firstIndex(matching: card) != nil
        }
        return false
    }
    
    // MARK: - Intents
    func startGame() {
        game = SetGame()
        game.startGame()
    }
    
    func choose(card: SetCard) {
        game.choose(card)
    }
    
    func dealCards(by player: SetPlayer) {
        game.dealCards(by: player)
    }
    
    func claimSet(for player: SetPlayer) {
        game.claimSet(for: player)
    }
}


