//
//  IconView.swift
//  AllTheicons
//
//  Created by Zev Eisenberg on 8/23/20.
//

import BigNumber
import UIKit

@IBDesignable final class IconView: UIView {

    // Public Properties

    @IBInspectable var value: Float = 0 { // should be clamped from 0 to 1
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var segments: Int = 0 {
        didSet {
            squareCount = segments * segments
            maxValue = ceil(pow(2, squareCount) - 1)
            setNeedsDisplay()
        }
    }

    var squareCount: Int = 0
    var maxValue: BInt = 0

    // Private Properties

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let doubleOfValue = BDouble(floatLiteral: Double(value))
        let intToRender = ceil(maxValue * doubleOfValue)

        let dividers = segments - 1
        let dividerWidth: CGFloat = 1
        // Assumes bounds is a square
        let segmentWidth = (bounds.width - dividerWidth) / CGFloat(segments)

        // Stroke border
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(dividerWidth * 2) // half inside, half outside
        context.stroke(bounds)

        // Grid lines

        for number in 0..<dividers {
            let verticalRect = CGRect(
                x: (CGFloat(number) + 1) * segmentWidth,
                y: 0,
                width: dividerWidth,
                height: bounds.height)

            let horizontalRect = CGRect(
                x: 0,
                y: (CGFloat(number) + 1) * segmentWidth,
                width: bounds.width,
                height: dividerWidth)

            context.addRect(verticalRect)
            context.addRect(horizontalRect)
        }

        // Squares

        for i in 0..<squareCount {
            if (intToRender >> BInt(i)) & 1 == 1 { // is the ith digit 1?
                let col = CGFloat(i % segments)
                let row = CGFloat(i / segments) // assuming truncation/floor
                let square = CGRect(
                    x: col * segmentWidth,
                    y: row * segmentWidth,
                    width: segmentWidth,
                    height: segmentWidth
                )
                context.addRect(square)
            }
        }

        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
    }

}
