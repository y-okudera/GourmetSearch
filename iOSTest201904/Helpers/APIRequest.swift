//
//  APIRequest.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire

// MARK: - Protocol
protocol APIRequest {
    
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var httpHeaderFields: [String: String] { get }
    
    func decode(data: Data) -> Response?
    
    /// URLRequestを生成する
    func makeURLRequest(needURLEncoding: Bool) -> URLRequest?
}

// MARK: - Default implementation
extension APIRequest {
    
    var baseURL: URL {
        guard let url = URL(string: "https://webservice.recruit.co.jp/hotpepper") else {
            fatalError("baseURL is nil.")
        }
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/path"
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var httpHeaderFields: [String: String] {
        return [:]
    }
    
    func decode(data: Data) -> Response? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            print(debug: "Response decode error:\(error)")
            return nil
        }
    }
    
    func makeURLRequest(needURLEncoding: Bool = false) -> URLRequest? {
        
        let endPoint = baseURL.absoluteString + path
        
        // String to URL
        guard let url = URL(string: endPoint) else {
            assertionFailure("エンドポイントが不正\nendPoint:\(endPoint)")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        urlRequest.timeoutInterval = 30
        
        if !needURLEncoding {
            return urlRequest
        }
        
        // パラメータをエンコードする
        do {
            urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        } catch {
            assertionFailure("エンコーディング処理でエラー発生\nURLRequest:\(urlRequest)")
            return nil
        }
    }
}
