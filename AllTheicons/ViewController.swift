//
//  ViewController.swift
//  AllTheicons
//
//  Created by Zev Eisenberg on 8/23/20.
//

import BigNumber
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        valueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        iconView.delegate = self
        updateIconView()
    }

    @IBAction func sliderSlid(_ sender: UISlider) {
        updateIconView()
    }

}

private extension ViewController {

    func updateIconView() {
        iconView.value = slider.value
        valueLabel.text = iconView.model.intToRender.asString(radix: 10)
    }

}

extension ViewController: IconViewDelegate {

    func iconViewChangedValue(_ iconView: IconView) {
        valueLabel.text = iconView.model.intToRender.asString(radix: 10)
    }

}
