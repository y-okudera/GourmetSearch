//
//  GourmetSearchAPIResponse.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct GourmetSearchAPIResponse: Decodable {
    var results = GourmetSearchResults()
}

struct GourmetSearchResults: Decodable {
    var shop = [Shop]()
}

struct Shop: Decodable {
    var id = ""
    var name = ""
    var lat = ""
    var lng = ""
    var genre = Genre()
    var open = ""
    var mobileAccess = ""
    var urls = ShopURLs()
}

struct ShopURLs: Decodable {
    var pc = ""
}
