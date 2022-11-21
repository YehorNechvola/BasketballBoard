//
//  UIView+Extension.swift
//  BasketballBoard
//
//  Created by Егор on 08.11.2022.
//

import UIKit

extension UIView {
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.3
      }
}
