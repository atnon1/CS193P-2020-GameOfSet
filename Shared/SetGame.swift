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

    init() {
        deck = []
        for symbol in [SetCard.SetSymbol.diamond] { //SetCard.SetSymbol.allCases {
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
                        if let newCard = deck.popLast() {
                            openCards.insert(newCard, at: idx)
                        }
                    }
                }
                matchedSets.append(matchedSet)
            }
        }
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
                } else {
                    for idx in choosenCardsIndices {
                        openCards[idx].isWrongSet = true
                    }
                }
            }
        }
    }
    
    mutating func startGame() {
        self = SetGame.init()
        dealCards(spaceOnTable)
    }
    
    mutating func dealCards() {
        dealCards(additionalCardNumber)
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
    
    
    // MARK: Constants
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
    var isFaceUp = true
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
