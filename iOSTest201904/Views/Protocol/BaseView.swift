//
//  BaseView.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

protocol BaseView: class {
    func showIndicator()
    func hideIndicator()
}

extension BaseView where Self: UIViewController {
    
    func showIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.startAnimating()
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.stopAnimating()
        }
    }
}
