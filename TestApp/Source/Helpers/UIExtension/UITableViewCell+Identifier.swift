//
//  UITableViewCell+Identifier.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        String(describing: self)
    }
}
