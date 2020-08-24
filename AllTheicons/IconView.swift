//
//  IconView.swift
//  AllTheicons
//
//  Created by Zev Eisenberg on 8/23/20.
//

import UIKit

@IBDesignable final class IconView: UIView {

    private let segments = 10

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.blue.cgColor)
        context.fillEllipse(in: rect)
    }

}
