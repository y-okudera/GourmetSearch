//
//  RestaurantDetailViewController+WKUIDelegate.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit
import WebKit

// MARK: - WKUIDelegate
extension RestaurantDetailViewController: WKUIDelegate {
    
    /// _blank挙動対応
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        guard
            let targetFrame = navigationAction.targetFrame,
            targetFrame.isMainFrame else {
                webView.load(navigationAction.request)
                return nil
        }
        return nil
    }
    
    /// プレビュー表示の許可
    func webView(_ webView: WKWebView,
                 shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    /// JavaScriptのAlertを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Swift.Void) {
        
        hideIndicator()
        showAlert(message: message) { _ in
            completionHandler()
        }
    }
    
    /// JavaScriptのConfirmを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        hideIndicator()
        showConfirm(message: message, positiveHandler: { _ in
            completionHandler(true)
        }) { _ in
            completionHandler(false)
        }
    }
    
    /// JavaScriptのPromptを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        hideIndicator()
        showPrompt(promptMessage: prompt, defaultText: defaultText) { text in
            completionHandler(text)
        }
    }
}
