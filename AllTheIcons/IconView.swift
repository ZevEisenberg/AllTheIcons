//
//  IconView.swift
//  AllTheIcons
//
//  Created by Zev Eisenberg on 8/23/20.
//

import BigNumber
import UIKit

protocol IconViewDelegate: AnyObject {
    func iconViewChangedValue(_ iconView: IconView)
}

@IBDesignable final class IconView: UIView {

    // Public Properties

    typealias Delegate = IconViewDelegate
    weak var delegate: Delegate?

    @IBInspectable var value: Float { // should be clamped from 0 to 1
        get { model.value }
        set { model.value = newValue }
    }

    @IBInspectable var segments: Int {
        get { model.segments }
        set { model.segments = newValue }
    }

    private(set) var model = IconModel(value: 0, segments: 32) {
        didSet {
            update()
        }
    }

    // Private Properties

    private var currentBrushValue = false // value to set bits to while drawing

    // Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let dividers = model.segments - 1
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

        for i in 0..<model.squareCount {
            if (model.intToRender >> BInt(i)) & 1 == 1 { // is the ith digit 1?
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

    func incrementValueIfPossible() {
        model.incrementValueIfPossible()
    }

    func decrementValueIfPossible() {
        model.decrementValueIfPossible()
    }

}

private extension IconView {

    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        let bitIndex = getBitIndex(at: gesture.location(in: self))
        model.toggleBit(atIndex: bitIndex)
    }

    @objc func panned(_ gesture: UIPanGestureRecognizer) {
        let bitIndex = getBitIndex(at: gesture.location(in: self))
        switch gesture.state {
        case .began:
            let startBit = model.getBit(atIndex: bitIndex)
            let newValue = !startBit
            currentBrushValue = newValue
        case .changed:
            model.updateBit(atIndex: bitIndex, to: currentBrushValue)
        default:
            break
        }
    }

}

private extension IconView {

    func sharedSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        addGestureRecognizer(pan)
    }

    func update() {
        setNeedsDisplay()
        delegate?.iconViewChangedValue(self)
    }

    func getBitIndex(at location: CGPoint) -> Int {
        let normalizedX = (location.x / bounds.size.width).clamped(to: 0...1)
        let normalizedY = (location.y / bounds.size.height).clamped(to: 0...1)
        let col = Int(floor(normalizedX * CGFloat(segments)))
        let row = Int(floor(normalizedY * CGFloat(segments)))
        let bitIndex = (segments * row) + col
        return bitIndex
    }

}

private extension Comparable {
    func clamped(to range: Range<Self>) -> Self {
        max(range.lowerBound, min(self, range.upperBound))
    }

    func clamped(to range: ClosedRange<Self>) -> Self {
        max(range.lowerBound, min(self, range.upperBound))
    }
}
