//
//  UIVIewController+Ext.swift
//  News
//
//  Created by Ismailov Farrukh on 11/01/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, preferedStyle: UIAlertController.Style, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferedStyle)
        let action = UIAlertAction(title: BookmarkScreen.delete, style: .destructive, handler: completion)
        let cancel = UIAlertAction(title: BookmarkScreen.cancel, style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
