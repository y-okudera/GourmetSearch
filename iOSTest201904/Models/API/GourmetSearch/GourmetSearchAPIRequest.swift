//
//  GourmetSearchAPIRequest.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire

final class GourmetSearchAPIRequest: APIRequest {
    typealias Response = GourmetSearchAPIResponse
    
    init(genre: Genre, currentLat: Double, currentLng: Double) {
        self.genre = genre
        self.currentLat = currentLat
        self.currentLng = currentLng
    }
    
    private var genre: Genre
    private var currentLat: Double
    private var currentLng: Double
    var path: String = "/gourmet/v1/"
    lazy var parameters: [String: Any] = makeParameters()
    
    private func makeParameters() -> [String: String] {
        let parameters = [
            "key": Constants.Hotpepper.apiKey,
            "format": "json",
            "genre": "\(self.genre.code)",
            "lat":"\(self.currentLat)",
            "lng":"\(self.currentLng)",
        ]
        return parameters
    }
}
