//
//  UIViewController+ShowAlert.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String = "Внимание", message: String) {

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Oк", style: .default, handler: nil))

        present(ac, animated: true, completion: nil)
    }
}
