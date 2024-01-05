//
//  UIViewExtensions.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
