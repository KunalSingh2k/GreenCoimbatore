//
//  ViewEx.swift
//  GreenCoimbatore
//
//  Created by Kunal on 25/03/23.
//

import UIKit

extension UIView {
    func roundedBorder(cornerRadius: CGFloat = 8) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
