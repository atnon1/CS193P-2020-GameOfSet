//
//  GameOfSetView.swift
//  Shared
//
//  Created by Anton Makeev on 16.12.2020.
//

import SwiftUI

struct GameOfSetView: View {
    
    
    var columns = [
        GridItem(.flexible(minimum: 20), spacing: 0),
        GridItem(.flexible(minimum: 20), spacing: 0),
        GridItem(.flexible(minimum: 20), spacing: 0)
    ]
    @ObservedObject var game : SetGameProvider
    @State var setButtonIsDisabled = false
    @State var showCheat = false
    @ViewBuilder
    var body: some View {
       // var deckPosition = CGRect.zero
        VStack(alignment: .center) {
            HStack{
                Button(action: {
                    withAnimation {
                        game.startGame()
                    }
                }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                )
                .padding()
                Text("P2 score: \(Int(game.score.secondPlayer))")
                    .rotationEffect(Angle.degrees(180))
                setButtonView(for: .playerTwo)
                    .rotationEffect(Angle.degrees(180))
                    .padding(.horizontal)
                dealButtonView(for: .playerTwo)
                    .rotationEffect(Angle.degrees(180))
            }

            Grid(game.cardsOnTable) { card in
                SetCardView(card: card, showCheat: game.cheatSetContains(card: card) && showCheat)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding()
                    .scaleEffect(card.isChoosen ? choosenCardScale : 1)
                    .animation(.linear)
                    .layoutPriority(10)
                    .rotationEffect(Angle.degrees(card.isMatched ? cardMatchRotationDegree : cardDefaultRotationDegree))
                    .transition(randomOutsideOffset())
                    .onTapGesture {
                        withAnimation(.linear(duration: 1)){
                            game.choose(card: card)
                            showCheat = false
                        }
                    }
               // }
            }
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    game.startGame()
                }
            }
            HStack {
                dealButtonView(for: .playerOne)
                setButtonView(for: .playerOne)
                .padding()
                Text("P1 score: \(Int(game.score.firstPlayer))")
                Button(
                    action: {withAnimation(Animation.linear(duration: 0.5).repeatCount(3)) {
                        showCheat = true
                        }
                    },
                    label: {
                    Text("Cheat")
                    }
                )
                .padding()
            }
        }
    }
    
    func dealButtonView(for player: SetPlayer) -> some View {
        Button (action: {
            withAnimation {
                game.dealCards(by: player)
            }
        }, label: {
            Text("Deal 3 cards")
            }
        )
        .disabled(game.deck.isEmpty)
    }
    
    func setButtonView(for player: SetPlayer) -> some View {
        Button(action: {
            tapSet(by: player)
        }, label: {
            Text("SET")
        })
        .disabled(setButtonIsDisabled)
    }
    
    func tapSet(by player: SetPlayer) {
        game.claimSet(for: player)
        setButtonIsDisabled = true
        Timer.scheduledTimer(withTimeInterval: setButtonNotActiveInterval, repeats: false, block: {_ in setButtonIsDisabled = false})
    }
    
    func randomOutsideOffset() -> AnyTransition {
        let height = bounds.height
        let width = bounds.width
        let y: CGFloat = .random(in: height...(height + 100)) * CGFloat([-1,1].randomElement()!)
        let x: CGFloat = .random(in: width...(width + 100)) * CGFloat([-1,1].randomElement()!)
        
        return .offset(CGSize(width: x, height:y))

    }
    // MARK: -  Constants
    let bounds: CGRect = UIScreen.main.bounds
    let choosenCardScale: CGFloat = 1.2
    let cardMatchRotationDegree: Double = 360
    let cardDefaultRotationDegree: Double = 0
    let setButtonNotActiveInterval: Double = 5
}


struct SetCardView: View {
    let card: SetCard
    let showCheat: Bool
    
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
    
    func symbolView() -> some View {
        ZStack {
            switch card.symbol {
            case .oval:
                switch card.shading {
                case .open: Capsule().opacity(0)
                case .solid: Capsule().fill()
                case .striped: Capsule().stripes(color0: color)
                }
                Capsule().stroke(lineWidth: symbolStrokeWidth)
            case .diamond:
                switch card.shading {
                case .open: Diamond().opacity(0)
                case .solid: Diamond().fill()
                case .striped: Diamond().stripes(color0:  color)
                }
                Diamond().stroke(lineWidth: symbolStrokeWidth)
            case .squiggle:
                switch card.shading {
                case .open: Squiggle().opacity(0)
                case .solid: Squiggle().fill()
                case .striped: Squiggle().stripes(color0: color)
                }
                Squiggle().stroke(lineWidth: symbolStrokeWidth)
            }
        }
    }

    var body: some View {
        print(card)
        return GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .shadow(color: card.isMatched ? matchedColor : card.isWrongSet ? wrongColor : neitralColor, radius: card.isChoosen ? 5 : 0)
                    .shadow(color: card.isMatched ? matchedColor : card.isWrongSet ? wrongColor : neitralColor, radius: card.isChoosen ? 5 : 0)
                    .shadow(color: showCheat ? matchedColor : .clear, radius: 5)
                    .shadow(color: showCheat ? matchedColor : .clear, radius: 5)
                    .animation(.linear)
                VStack(spacing: nil) {
                    ForEach(Range(1...card.number)) { _ in
                        symbolView()
                    }
                    .aspectRatio(2/1, contentMode: .fit)
                    .padding(.vertical, incardPadding(viewSize: geometry.size))
                    .frame(width: symbolSize(viewSize:geometry.size).width, height:  symbolSize(viewSize:geometry.size).height)
                }
                .foregroundColor(self.color)
                .cardify(withFilling: Color.blue, isFaceUp: card.isFaceUp)
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(color: .black, radius: 5)
                    .foregroundColor(matchedColor)
                    .opacity(card.isMatched ? 1 : 0)
                    .padding()
                    .animation(.linear)
                    
            }
        }
    }
    
    // MARK: - Drawing constants
    func symbolSize(viewSize: CGSize) -> CGSize {
        let proportion: CGFloat = 0.7 * 0.95
        let symbolsNumber: CGFloat = 3
        return CGSize(width: viewSize.width * proportion * 0.9, height: viewSize.height * proportion / symbolsNumber )
    }
    func incardPadding(viewSize: CGSize) -> CGFloat {
        let proportion: CGFloat = 0.7 * 0.05
        let symbolsNumber: CGFloat = 3
        return viewSize.height * proportion / symbolsNumber
    }
    let symbolStrokeWidth: CGFloat = 1.0
    let solidOpacity: Double = 1
    let strippedOpacity: Double = 0.3
    let openOppacity: Double = 0
    let matchedColor = Color.green
    let neitralColor = Color.yellow
    let wrongColor = Color.red
    @Environment(\.colorScheme) var colorScheme

}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameProvider()
        game.startGame()
        return GameOfSetView(game: game)
    }
}

