//
//  MailScheme.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct MailScheme {
    
    /// 必須な要素の数 ([mailto:, <メールアドレス>])
    private static let countOfRequiredComponents = 2
    
    var toAddresses: [String]
    var cc: [String]?
    var bcc: [String]?
    var subject = ""
    var body = ""
    
    init?(url: URL) {
        
        // スキームチェック
        if !MailScheme.checkScheme(url: url) {
            return nil
        }
        
        var pathComponents = url.absoluteString.pathComponents
        
        // 必須要素[mailto:, <メールアドレス>]が欠けている
        if pathComponents.count < MailScheme.countOfRequiredComponents {
            return nil
        }
        
        // mailto:を除外
        pathComponents.removeFirst()
        
        guard let toAddresses = pathComponents.first else {
            return nil
        }
        self.toAddresses = toAddresses.components(separatedBy: ",")
        
        let queryParams = url.queryToDic()
        self.cc = queryParams["cc"]?.components(separatedBy: ",")
        self.bcc = queryParams["bcc"]?.components(separatedBy: ",")
        self.subject = queryParams["subject"] ?? ""
        self.body = queryParams["body"] ?? ""
    }
    
    /// スキームがmailtoであるかどうか
    private static func checkScheme(url: URL) -> Bool {
        
        guard let scheme = Scheme(rawValue: url.scheme ?? "") else {
            return false
        }
        if case .mailto = scheme {
            return true
        }
        return false
    }
}

private extension String {
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
}

private extension URL {
    func queryToDic() -> [String: String] {
        
        var queryParams = [String: String]()
        
        guard
            let urlComponents = URLComponents(string: absoluteString),
            let queryItems = urlComponents.queryItems else {
                return queryParams
        }
        
        for queryItem in queryItems {
            queryParams[queryItem.name] = queryItem.value
        }
        return queryParams
    }
}
