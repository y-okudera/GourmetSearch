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
    
    /// ジャンルマスタAPIリクエストをする
    func requestGenre()
    /// グルメサーチAPIリクエストをする
    func requestGourmetSearch(genre: Genre, currentLat: Double, currentLng: Double)
}

final class RestaurantSearchPresenterImpl: RestaurantSearchPresenter {
    
    private weak var view: RestaurantSearchView?
    
    required init(view: RestaurantSearchView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
    func requestGenre() {
        
        view?.showIndicator()
        
        let genreAPIRequest = GenreAPIRequest()
        APIClient.request(request: genreAPIRequest) { [weak self] result in
            switch result {
            case .success(object: let response):
                
                if let genreAPIResponse = response as? GenreAPIResponse {
                    GenreDao.add(genreApiResponse: genreAPIResponse)
                }
                self?.view?.hideIndicator()
            case .failure(apiError: let error):
                print(debug: "API Error: \(error)")
                self?.view?.hideIndicator()
            }
        }
    }
    
    func requestGourmetSearch(genre: Genre, currentLat: Double, currentLng: Double) {
        
        let gourmetSearchRequest = GourmetSearchAPIRequest(genre: genre, currentLat: currentLat, currentLng: currentLng)
        APIClient.request(request: gourmetSearchRequest) { [weak self] result in
            switch result {
            case .success(object: let response):
                
                self?.view?.hideIndicator()
                if let gourmetSearchAPIResponse = response as? GourmetSearchAPIResponse {
                    let shops = gourmetSearchAPIResponse.results.shop
                    self?.view?.didFinishGettingShops(shops: shops)
                }
                
            case .failure(apiError: let error):
                print(debug: "API Error: \(error)")
                self?.view?.hideIndicator()
            }
        }
    }
}
