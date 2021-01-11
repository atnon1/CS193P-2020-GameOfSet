//
//  RotationTransition.swift
//  Game of SET (iOS)
//
//  Created by Anton Makeev on 10.01.2021.
//

import SwiftUI

struct RotationModifier: ViewModifier {
    let degrees: Angle
    let anchor: UnitPoint
    func body(content: Content) -> some View {
        content.rotationEffect(degrees, anchor: anchor)//.clipped()
    }
}

extension AnyTransition {
    static var rotate: AnyTransition { //}(_ degrees: Angle, anchor: UnitPoint = .center) -> AnyTransition {
        .modifier(
            active: RotationModifier(degrees: Angle.degrees(360), anchor: .center),
            identity: RotationModifier(degrees: .zero, anchor: .center)
        )
    }
}
