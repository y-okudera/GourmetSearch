//
//  WebViewConstants.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

enum Scheme: String {
    case mailto = "mailto"
    case file = "file"
    case http = "http"
    case https = "https"
    case line = "line"
}

struct WebViewConstants {
    /// Webサイトのドメイン
    static let domain = "www.google.com"
    /// WebサイトのベースURL
    static let baseURL = "https://www.google.com"
}
