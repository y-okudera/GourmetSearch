//
//  GenreAPIRequest.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire

final class GenreAPIRequest: APIRequest {
    typealias Response = GenreAPIResponse
    
    var path: String = "/genre/v1/"
    var parameters: [String: Any] = [
        "key": Constants.Hotpepper.apiKey,
        "format": "json"
    ]
}
