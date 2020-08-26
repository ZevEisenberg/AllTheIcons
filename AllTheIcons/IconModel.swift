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

    mutating func toggleBit(atIndex index: Int) {
        let currentValue = getBit(atIndex: index)
        let newValue = !currentValue
        updateBit(atIndex: index, to: newValue)
    }

    mutating func updateBit(atIndex index: Int, to newValue: Bool) {
        // via https://stackoverflow.com/a/47990/255489

        if index == 0 {
            // special-case index 0 because it doesn't play nice with the bit shifting,
            // at least with this BigNum library, or else I don't understand bit
            // shifting, which is also likely.

            // If current value is even, least significant bit is 0
            let currentValue = !intToRender.isMultiple(of: 2)
            switch (currentValue, newValue) {
            case (true, true), (false, false): break
            case (true, false): intToRender -= 1
            case (false, true): intToRender += 1
            }
        }
        else if newValue {
            let newBit = BInt(1) << index
            intToRender |= newBit
        } else {
            intToRender ^= (1 ^ intToRender) & (1 << index)
        }
        updateValue()
    }

    mutating func incrementValueIfPossible() {
        guard intToRender < maxValue else { return }
        intToRender += 1
        updateValue()
    }

    mutating func decrementValueIfPossible() {
        guard intToRender > 0 else { return }
        intToRender -= 1
        updateValue()
    }

    func getBit(atIndex index: Int) -> Bool {
        ((intToRender >> index) & 1) == 1
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

    mutating func updateValue() {
        updatingInternally = true
        defer { updatingInternally = false }
        value = Float(BDouble(intToRender, over: maxValue).decimalExpansion(precisionAfterDecimalPoint: 60)) ?? 0
    }
}
