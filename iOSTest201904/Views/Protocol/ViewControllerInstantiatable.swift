//
//  ViewControllerInstantiatable.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - ViewControllerInstantiatable
protocol ViewControllerInstantiatable where Self: UIViewController {}

extension ViewControllerInstantiatable {
    
    static func instantiate(bundle: Bundle? = Bundle(for: Self.self)) -> Self {
        
        let storyboardName = String(describing: self)
        
        guard let viewController = UIStoryboard(name: storyboardName, bundle: bundle)
            .instantiateInitialViewController() as? Self else {
                fatalError("viewController is nil. Storyboard Name: \(storyboardName)")
        }
        return viewController
    }
    
    static func instantiateWithIdentifier(_ identifier: String = String(describing: Self.self),
                                          bundle: Bundle? = Bundle(for: Self.self)) -> Self {
        
        let storyboardName = String(describing: self)
        
        guard let viewController = UIStoryboard(name: storyboardName, bundle: bundle)
            .instantiateViewController(withIdentifier: identifier) as? Self else {
                fatalError("viewController is nil. Name: \(storyboardName), Identifier: \(identifier)")
        }
        return viewController
    }
}

extension UIViewController: ViewControllerInstantiatable {}
