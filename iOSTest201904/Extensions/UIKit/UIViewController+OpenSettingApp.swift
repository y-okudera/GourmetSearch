//
//  UIViewController+OpenSettingApp.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func openSettingApp() {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return
        }
        guard let url = URL(string: "app-settings:root=General&path=\(bundleId)") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showAppSettingAlert(presenting viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(
            title: "",
            message: "位置情報が許可されていません。\n設定アプリに移動して、位置情報を許可しますか？",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.openSettingApp()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
