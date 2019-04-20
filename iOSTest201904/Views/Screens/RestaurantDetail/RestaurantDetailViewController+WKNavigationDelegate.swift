//
//  RestaurantDetailViewController+WKNavigationDelegate.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit
import WebKit

// MARK: - WKNavigationDelegate (ロード処理)
extension RestaurantDetailViewController: WKNavigationDelegate {
    
    /// リクエスト開始処理をフック
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            // 読み込みをキャンセル
            decisionHandler(.cancel)
            return
        }
        print("Request URL: \(url.absoluteString)")
        guard let scheme = Scheme(rawValue: url.scheme ?? "") else {
            // 読み込みを許可
            decisionHandler(.allow)
            return
        }
        switch scheme {
        case .mailto:
            // 読み込みをキャンセルし、メーラを起動
            decisionHandler(.cancel)
            guard let mailScheme = MailScheme(url: url) else {
                return
            }
            sendMail(mailScheme: mailScheme)
        case .file:
            decisionHandler(.allow)
        case .http:
            decisionHandler(.allow)
        case .https:
            decisionHandler(.allow)
        case .line:
            decisionHandler(.cancel)
            openSafari(url: url)
        }
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /// 読み込み開始
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        didChangeLoadingStatus(status: .started)
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        didChangeLoadingStatus(status: .finished)
    }
    
    /// 読み込み中エラー発生
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        didChangeLoadingStatus(status: .occurredError(error))
    }
    
    /// 通信中エラー発生
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        didChangeLoadingStatus(status: .occurredError(error))
    }
}
