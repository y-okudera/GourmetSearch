//
//  APIClient.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation

enum APIError: Error {
    /// 接続エラー(オフライン or タイムアウト)
    case connectionError
    
    /// レスポンスのデコード失敗
    case decodeError
    
    /// エラーレスポンス
    case errorResponse(errObject: Decodable)
    
    /// 無効なリクエスト
    case invalidRequest
    
    /// 無効なレスポンス
    case invalidResponse
    
    /// その他
    case others(error: Error, statusCode: Int?)
}

enum APIResult {
    /// 成功
    case success(object: Decodable)
    
    /// 失敗
    case failure(apiError: APIError)
}

final class APIClient: NSObject {
    
    /// 端末の通信状態を取得
    ///
    /// - Returns: true: オンライン, false: オフライン
    static func isOnline() -> Bool {
        if let reachabilityManager = NetworkReachabilityManager() {
            reachabilityManager.startListening()
            return reachabilityManager.isReachable
        }
        return false
    }
    
    /// API Request
    static func request<T: APIRequest>(request: T, completionHandler: @escaping (APIResult) -> Void) {
        
        // 端末の通信状態をチェック
        if !isOnline() {
            completionHandler(.failure(apiError: .connectionError))
            return
        }
        
        guard let urlRequest = request.makeURLRequest(needURLEncoding: true) else {
            completionHandler(.failure(apiError: .invalidRequest))
            return
        }
        print(debug: "urlRequest: \(urlRequest)")
        Alamofire.request(urlRequest).validate(statusCode: 200 ..< 300).responseData { dataResponse in
            
            // エラーチェック
            if let error = dataResponse.result.error {
                let apiError = errorToAPIError(error: error, statusCode: dataResponse.response?.statusCode)
                completionHandler(.failure(apiError: apiError))
                return
            }
            
            // レスポンスデータのnilチェック
            guard let responseData = dataResponse.result.value else {
                completionHandler(.failure(apiError: .invalidResponse))
                return
            }
            
            let result = self.decode(responseData: responseData, request: request)
            completionHandler(result)
        }
    }
}

extension APIClient {
    
    /// ErrorをAPIErrorに変換する
    private static func errorToAPIError(error: Error, statusCode: Int?) -> APIError {
        print(debug: "HTTPステータスコード:\(String(describing: statusCode))")
        if let error = error as? URLError {
            if error.code == .timedOut {
                print(debug: "タイムアウト")
                return .connectionError
            }
            if error.code == .notConnectedToInternet {
                print(debug: "端末がインターネットにつながっていない")
                return .connectionError
            }
        }
        print(debug: "dataResponse.result.error:\(error)")
        return .others(error: error, statusCode: statusCode)
    }
    
    /// デコード
    private static func decode<T: APIRequest>(responseData: Data, request: T) -> APIResult {
        if let object = request.decode(data: responseData) {
            print(debug: "レスポンス:\(object)")
            return .success(object: object)
        } else {
            print(debug: "デコード失敗")
            return .failure(apiError: .decodeError)
        }
    }
}
