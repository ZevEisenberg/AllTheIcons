//
//  IconModel.swift
//  AllTheIcons
//
//  Created by Zev Eisenberg on 8/24/20.
//

import BigNumber

struct IconModel {

    var value: Float = 0 { // should be clamped from 0 to 1
        didSet {
            if !updatingInternally {
                update()
            }
        }
    }

    var segments: Int = 0 {
        didSet {
            update()
        }
    }

    private var updatingInternally = false

    private(set) var squareCount: Int = 0
    private(set) var maxValue: BInt = 0 // the maximum number, equal to 2ⁿ where n = squareCount
    private(set) var intToRender: BInt = 0 // value * maxValue

    init(value: Float, segments: Int) {
        self.value = value
        self.segments = segments
        update()
    }

    mutating func updateBit(atIndex index: Int, to newValue: Bool) {
        if newValue {
            intToRender |= (BInt(1) << index)
        } else {
            intToRender &= ~(BInt(1) << index)
        }
        updatingInternally = true
        defer { updatingInternally = false }
        value = Float(BDouble(intToRender, over: maxValue).decimalExpansion(precisionAfterDecimalPoint: 60)) ?? 0
    }
}

private extension IconModel {
    mutating func update() {
        squareCount = segments * segments
        maxValue = ceil(pow(2, squareCount) - 1)
        // Need a floating point value to be able to multiply by value
        let doubleOfValue = BDouble(floatLiteral: Double(value))
        intToRender = ceil(maxValue * doubleOfValue)
    }
}
