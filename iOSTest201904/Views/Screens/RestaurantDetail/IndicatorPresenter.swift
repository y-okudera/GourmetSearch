//
//  IndicatorPresenter.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

protocol IndicatorPresenter {
    
    var activityIndicator: UIActivityIndicatorView { get }
    
    /// インジケータを表示する
    func showIndicator()
    
    /// インジケータを非表示にする
    func hideIndicator()
}

extension IndicatorPresenter where Self: UIViewController {
    
    func showIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.style = .whiteLarge
            self.activityIndicator.color = #colorLiteral(red: 0.2722781003, green: 0.2722781003, blue: 0.2722781003, alpha: 1)
            self.activityIndicator.frame = CGRect(
                x: 0,
                y: 0,
                width: self.view.bounds.size.width * 0.1,
                height: self.view.bounds.size.width * 0.1
            )
            self.activityIndicator.center = CGPoint(
                x: self.view.bounds.size.width / 2,
                y: self.view.bounds.height / 2
            )
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
