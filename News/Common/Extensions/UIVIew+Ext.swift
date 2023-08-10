//
//  UIVIew+Ext.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
