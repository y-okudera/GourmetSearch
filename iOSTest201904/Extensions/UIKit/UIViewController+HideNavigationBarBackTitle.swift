//
//  UIViewController+HideNavigationBarBackTitle.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// バックボタンのタイトルを非表示にする
    func hideNavigationBarBackTitle() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }
}
