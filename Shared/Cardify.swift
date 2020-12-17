//
//  Cardify.swift
//  Memorize
//
//  Created by Anton Makeev on 12.12.2020.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get {return rotation}
        set {rotation = newValue}
    }
    
    // Filling vars
    var linearGradient: LinearGradient?
    var radialGradient: RadialGradient?
    var angularGradient: AngularGradient?
    var color: Color?

    // Complication mostly defined by Extra credit task - To add gradient filling
    func body(content: Content) -> some View {
        ZStack{
            if let filling = color {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(filling, lineWidth: edgeLineWidth)
                    content
                }
                    .opacity(isFaceUp ? 1 : 0)
                RoundedRectangle(cornerRadius: cornerRadius).fill(filling)
                    .opacity(isFaceUp ? 0 : 1)
            } else if let filling = linearGradient {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(filling, lineWidth: edgeLineWidth)
                    content
                }
                    .opacity(isFaceUp ? 1 : 0)
                RoundedRectangle(cornerRadius: cornerRadius).fill(filling)
                    .opacity(isFaceUp ? 0 : 1)
            } else if let filling = radialGradient {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(filling, lineWidth: edgeLineWidth)
                    content
                }
                    .opacity(isFaceUp ? 1 : 0)
                RoundedRectangle(cornerRadius: cornerRadius).fill(filling)
                    .opacity(isFaceUp ? 0 : 1)
            } else if let filling = angularGradient {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(filling, lineWidth: edgeLineWidth)
                    content
                }
                    .opacity(isFaceUp ? 1 : 0)
                RoundedRectangle(cornerRadius: cornerRadius).fill(filling)
                    .opacity(isFaceUp ? 0 : 1)
            } else {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    content
                }
                    .opacity(isFaceUp ? 1 : 0)
                RoundedRectangle(cornerRadius: cornerRadius).fill()
                    .opacity(isFaceUp ? 0 : 1)
            }
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (0,1,0)
        )
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    // Creates card with stroke and back filled with specified `filling`
    init<S: ShapeStyle>(withFilling filling: S, isFaceUp: Bool ) {
        self.init(isFaceUp: isFaceUp)
        color = filling as? Color
        linearGradient = filling as? LinearGradient
        radialGradient = filling as? RadialGradient
        angularGradient = filling as? AngularGradient
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
}


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
    
    func cardify<S: ShapeStyle>(withFilling filling: S, isFaceUp: Bool) -> some View {
        self.modifier(Cardify(withFilling: filling, isFaceUp: isFaceUp))
    }

}


