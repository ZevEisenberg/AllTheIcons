//
//  ViewController.swift
//  AllTheicons
//
//  Created by Zev Eisenberg on 8/23/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateIconView()
    }

    @IBAction func sliderSlid(_ sender: UISlider) {
        updateIconView()
    }

}

private extension ViewController {

    func updateIconView() {
        iconView.value = slider.value
    }

}
