//
//  RestaurantSearchPresenter.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

protocol RestaurantSearchPresenter: class {
    init(view: RestaurantSearchView)
    func detachView()
}

final class RestaurantSearchPresenterImpl: RestaurantSearchPresenter {
    
    private weak var view: RestaurantSearchView?
    
    required init(view: RestaurantSearchView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
}
