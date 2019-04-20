//
//  RestaurantSearchViewController.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import MapKit
import UIKit

/// レストラン検索画面
final class RestaurantSearchViewController: UIViewController {

    lazy var presenter: RestaurantSearchPresenter = RestaurantSearchPresenterImpl(view: self)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - RestaurantSearchView
extension RestaurantSearchViewController: RestaurantSearchView {
    
}
