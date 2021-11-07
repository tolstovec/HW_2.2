//
//  ColorViewController.swift
//  HW_2.2
//
//  Created by Ilya Pokhodin on 07.11.2021.
//

import UIKit

protocol ChoosenColorViewControlletDelegate {
    func setNewViewBackgroundColor(for newValue: UIColor)
}

class ColorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chooseColorVC = segue.destination as? ChooseColorViewController else { return }
        chooseColorVC.colorFromColorVC = view.backgroundColor
        chooseColorVC.delegate = self
    }

}

extension ColorViewController: ChoosenColorViewControlletDelegate {
    func setNewViewBackgroundColor(for newValue: UIColor) {
        view.backgroundColor = newValue
    }
}
