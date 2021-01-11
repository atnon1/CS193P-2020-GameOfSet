//
//  StripedShape.swift
//  Game of SET (iOS)
//
//  Created by Anton Makeev on 11.01.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

extension CGImage {
    static func generateStripePattern(
        color0: UIColor = .black,
        color1: UIColor = .clear,
        width: CGFloat = 2,
        ratio: CGFloat = 1) -> CGImage? {

    let context = CIContext()
    let stripes = CIFilter.stripesGenerator()
    stripes.color0 = CIColor(color: color0)
    stripes.color1 = CIColor(color: color1)
    stripes.width = Float(width)
    stripes.center = CGPoint(x: 1 - width * ratio, y: 0)
    let size = CGSize(width: width, height: 1)

    guard
        let stripesImage = stripes.outputImage,
        let image = context.createCGImage(stripesImage, from: CGRect(origin: .zero, size: size))
    else { return nil }
    return image
  }
}

extension Shape {
    func stripes(angle: Double = 0, color0: Color = .black, color1: Color = .clear) -> AnyView {
        guard
            let stripePattern = CGImage.generateStripePattern(color0: UIColor(color0), color1: UIColor(color1))
        else { return AnyView(self)}

        return AnyView(Rectangle().fill(ImagePaint(
            image: Image(decorative: stripePattern, scale: 1.0)))
        .rotationEffect(.degrees(angle))
        .clipShape(self))
    }
}
