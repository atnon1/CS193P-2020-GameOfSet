//
//  SetGame.swift
//  Game of SET
//
//  Created by Anton Makeev on 16.12.2020.
//

import Foundation

struct SetGame {
    var score = SetScore()
    var deck: [SetCard]
    var openCards: [SetCard]
    var matchedSets: [[SetCard]] = []
    var choosenCardsIndices: [Int] {
        get {
            var indices = [Int]()
            for idx in openCards.indices {
                if openCards[idx].isChoosen == true {
                    indices.append(idx)
                }
            }
            return indices
        }
        set {
            if newValue.isEmpty {
                for idx in openCards.indices {
                    openCards[idx].isChoosen = false
                }
            }
        }
    }
    var firstOpenSet: (SetCard, SetCard, SetCard)? {
        for idx1 in 0..<openCards.count - 2 {
            for idx2 in idx1+1..<openCards.count - 1 {
                for idx3 in idx2+1..<openCards.count {
                    if cardsMakeSet(cards: [openCards[idx1], openCards[idx2], openCards[idx3]]) {
                        return (openCards[idx1], openCards[idx2], openCards[idx3])
                    }
                }
            }
        }
        return nil
    }

    init() {
        deck = []
        for symbol in [SetCard.SetSymbol.diamond] { // SetCard.SetSymbol.allCases { //
            for shading in SetCard.SetShading.allCases {
                for color in SetCard.SetColor.allCases  {
                    for number in (1...symbolMaxNumber) {
                        deck.append(SetCard(symbol: symbol, shading: shading, color: color, number: number, id: deck.count))
                    }
                }
            }
        }
        deck.shuffle()
        openCards = []
    }
    
    mutating func choose(_ card: SetCard) {
        let indices = choosenCardsIndices
        if choosenCardsIndices.count == setCardsNumber {
            choosenCardsIndices = []
            if openCards[indices.first!].isMatched == true {
                var matchedSet = [SetCard]()
                for idx in indices.sorted(by: >) {
                    matchedSet.append(openCards.remove(at: idx))
                    if openCards.count < spaceOnTable {
                        if var newCard = deck.popLast() {
                            newCard.isFaceUp = true
                            openCards.insert(newCard, at: idx)
                        }
                    }
                }
                matchedSets.append(matchedSet)
            }
        }
        if score.currentPlayer != nil {
            if let mathingIndex = openCards.firstIndex(matching: card) {
                print("Choosen \(openCards[mathingIndex])")
                if !(indices.contains(mathingIndex) && indices.count == setCardsNumber) {
                    openCards[mathingIndex].isChoosen = !openCards[mathingIndex].isChoosen
                }
                if choosenCardsIndices.count == setCardsNumber {
                    if cardsMakeSet(cards: choosenCardsIndices.map {openCards[$0]}) {
                        for idx in choosenCardsIndices {
                            print("SET")
                            openCards[idx].isMatched = true
                        }
                        score.getPoints()
                    } else {
                        for idx in choosenCardsIndices {
                            openCards[idx].isWrongSet = true
                        }
                    }
                }
            }
        }
    }
    
    mutating func startGame() {
        self = SetGame.init()
        dealCards(spaceOnTable)
    }
    
    mutating func dealCards(by player: SetPlayer) {
        if firstOpenSet != nil {
            score.getPenalty(for: player)
        }
        dealCards(additionalCardNumber)
    }
    
    mutating func claimSet(for player: SetPlayer) {
        score.setTimer(for: player)
    }
    
    private mutating func dealCards(_ quantity: Int) {
        if !deck.isEmpty {
            let cardsToInsert: [SetCard] = Array(deck[..<min(quantity, deck.count)]).map{
                var card = $0
                card.isFaceUp = true
                return card
            }
            let indices = choosenCardsIndices.sorted(by: >)
            for idx in 0..<cardsToInsert.count {
                if idx < setCardsNumber {
                    if indices.count == setCardsNumber && openCards[indices.last!].isMatched == true {
                        openCards[indices[idx]] = cardsToInsert[idx]
                        continue
                    }
                }
                openCards.append(cardsToInsert[idx])
            }
            deck.removeSubrange(..<min(quantity, deck.count))
        }
    }
    // Checks if given values make Set
    func cardsMakeSet(cards: [SetCard]) -> Bool {
        let symbols = cards.map {$0.symbol}
        let colors = cards.map {$0.color}
        let shadings = cards.map {$0.shading}
        let numbers = cards.map {$0.number}
        
        func valuesMakeSet<T: Hashable> (_ values: [T])-> Bool{
            if values.areEqual() || values.areUnique() {
                return true
            }
            return false
        }
        
        return valuesMakeSet(symbols) && valuesMakeSet(colors) && valuesMakeSet(shadings) &&  valuesMakeSet(numbers)
    }
    
    // MARK: - Constants
    private let symbolMaxNumber = 3
    private let spaceOnTable = 12
    private let additionalCardNumber = 3
    private let setCardsNumber = 3
}

struct SetCard: Identifiable {
    let symbol: SetSymbol
    let shading: SetShading
    let color: SetColor
    let number: Int
    var isFaceUp = false
    var isChoosen = false {
        willSet{
            if !newValue {
                isWrongSet = false
            }
        }
    }
    var isMatched = false
    var isWrongSet = false
    
    var id: Int
    
    enum SetSymbol: CaseIterable, Hashable {
        case diamond
        case squiggle
        case oval
    }
    
    enum SetShading: CaseIterable, Hashable {
        case solid
        case striped
        case open
    }
    
    enum SetColor: CaseIterable, Hashable {
        case purple
        case red
        case green
    }
}

enum SetPlayer {
    case playerOne
    case playerTwo
}

struct SetScore {
    private var playerOneScore: Double = 0
    private var playerTwoScore: Double = 0
    
    // how long this card has ever been face up
    private var setTimerTime: TimeInterval {
        if let lastSetDate = self.lastSetDate {
            return Date().timeIntervalSince(lastSetDate)
        } else {
            return 0
        }
    }
    // the last time this card was turned face up (and is still face up)
    var lastSetDate: Date?
    // the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var currentPlayer: SetPlayer?

    mutating func getPoints() {
        switch currentPlayer {
        case .playerOne: playerOneScore += countPoints(inTime: setTimerTime)
        case .playerTwo: playerTwoScore += countPoints(inTime: setTimerTime)
        default: break
        }
        lastSetDate = nil
        currentPlayer = nil
    }
    
    mutating func getPenalty(for player: SetPlayer) {
        switch player {
        case .playerOne: playerOneScore -= penaltyPoints
        case .playerTwo: playerTwoScore -= penaltyPoints
        }
    }
    
    mutating func setTimer(for player: SetPlayer) {
        if player != currentPlayer {
            currentPlayer = player
            lastSetDate = Date()
        }
    }
    
    private func countPoints(inTime time: Double) -> Double {
        switch time {
        case 0...(maximumPoints-1): return maximumPoints - time
        default:
            return defaultPoints
        }
    }
    
    var points: (firstPlayer: Double, secondPlayer: Double) {
        return (playerOneScore, playerTwoScore)
    }
    
    // MARK: - Constants
    private let maximumPoints = 10.0
    private let penaltyPoints = 5.0
    private let defaultPoints = 1.0
    
}
