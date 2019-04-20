//
//  RestaurantDetailViewController+JSAlertProtocol.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

extension RestaurantDetailViewController: JSAlertProtocol {
    
    private struct MessageConstants {
        static let ok = "OK"
        static let cancel = "Cancel"
    }
    
    func showAlert(title: String = "",
                   message: String,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: MessageConstants.ok, style: .default, handler: handler)
        )
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirm(title: String = "",
                     message: String,
                     positiveHandler: ((UIAlertAction) -> Void)? = nil,
                     negativeHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: MessageConstants.ok, style: .default, handler: positiveHandler)
        )
        alert.addAction(
            UIAlertAction(title: MessageConstants.cancel, style: .cancel, handler: negativeHandler)
        )
        present(alert, animated: true, completion: nil)
    }
    
    func showPrompt(title: String = "",
                    promptMessage: String,
                    defaultText: String?,
                    completionHandler: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: promptMessage, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = defaultText
        }
        alert.addAction(
            UIAlertAction(title: MessageConstants.ok, style: .default, handler: { _ in
                completionHandler(alert.textFields?.first?.text ?? "")
            })
        )
        alert.addAction(
            UIAlertAction(title: MessageConstants.cancel, style: .cancel, handler: { _ in
                completionHandler("")
            })
        )
        present(alert, animated: true, completion: nil)
    }
}
