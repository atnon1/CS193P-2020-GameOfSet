//
//  GameOfSetView.swift
//  Shared
//
//  Created by Anton Makeev on 16.12.2020.
//

import SwiftUI

struct GameOfSetView: View {
    @ObservedObject var game : SetGameProvider
    
    @ViewBuilder
    var body: some View {
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
                .padding(.horizontal)
                Spacer()
            }
            Grid(game.cardsOnTable) { card in
                SetCardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding()
                    .transition(randomOutsideOffset())
                   // .offset(x: card.isWrongSet ? 10 : 0)
                  //  .animation(Animation.default.repeatCount(3))
                    //.offset(x: card.isWrongSet ? -10 : 0)
                    //.animation(Animation.default.repeatCount(3))
                    .scaleEffect(card.isChoosen ? choosenCardScale : 1)
                    .onTapGesture {
                        withAnimation(.linear(duration: 1)){
                            game.choose(card: card)
                        }
                    }
                
            }
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    game.startGame()
                }
            }
            Button (action: {
                withAnimation {
                    game.dealCards()
                }
            }, label: {
                Text("Deal more cards")
                }
            )
            .disabled(game.deck.isEmpty)
            .padding()
        }
    }
    
    
    func randomOutsideOffset() -> AnyTransition {
        let height = bounds.height
        let width = bounds.width
        let y: CGFloat = .random(in: height...(height + 100)) * CGFloat([-1,1].randomElement()!)
        let x: CGFloat = .random(in: width...(width + 100)) * CGFloat([-1,1].randomElement()!)
        
        return .offset(CGSize(width: x, height:y))

    }
    // MARK: -Constants
    let bounds: CGRect = UIScreen.main.bounds
    let choosenCardScale: CGFloat = 1.2
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
        return GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .shadow(color: card.isMatched ? matchedColor : card.isWrongSet ? wrongColor : neitralColor, radius: card.isChoosen ? 5 : 0)
                    .shadow(color: card.isMatched ? matchedColor : card.isWrongSet ? wrongColor : neitralColor, radius: card.isChoosen ? 5 : 0)
                VStack(spacing: nil) {
                    ForEach(Range(1...card.number)) { _ in
                        ZStack{
                            switch card.symbol {
                            case .oval:
                                Capsule().fill()
                                    .opacity(opacityLevel)
                                Capsule().stroke(lineWidth: symbolStrokeWidth)
                            case .diamond:
                                Diamond().fill()
                                    .opacity(opacityLevel)
                                Diamond().stroke(lineWidth: symbolStrokeWidth)
                            case .squiggle:
                                Ellipse().fill()
                                    .opacity(opacityLevel)
                                Ellipse().stroke(lineWidth: symbolStrokeWidth)
                            }
                        }
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
    let symbolStrokeWidth: CGFloat = 3.0
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
        game.dealCards()
        game.dealCards()
        return GameOfSetView(game: game)
    }
}

