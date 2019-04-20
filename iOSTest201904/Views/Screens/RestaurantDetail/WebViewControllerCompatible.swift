//
//  WebViewControllerCompatible.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit
import WebKit

/// WebViewベース
protocol WebViewControllerCompatible where Self: UIViewController {
    
    var webView: WKWebView! { get set }
    /// 規定のURL(baseURLがnilの場合に使用)
    var defaultURL: String { get }
    /// 可変のURL
    var baseURL: String? { get set }
    
    /// WebViewの読み込み状況の変更を検知した際の処理
    ///
    /// - Parameter status: 変更後のステータス
    func didChangeLoadingStatus(status: WebLoadingStatus)
    
    /// 通信エラーのアラートを表示する
    func showConnectionErrorAlert()
    
    /// JSのアラートをUIAlertControllerで表示する
    ///
    /// - Parameter alertController: UIAlertController
    func jsAlert(alertController: UIAlertController)
    
    /// メーラを起動する
    ///
    /// - Parameter mailScheme: MailScheme情報
    func sendMail(mailScheme: MailScheme)
    
    /// Safariを起動する
    ///
    /// - Parameter url: URL情報
    func openSafari(url: URL)
}

/// ツールバー有り
protocol WebViewToolBarCompatible where Self: UIViewController {
    
    /// 戻るボタン
    var backButton: UIBarButtonItem! { get set }
    
    /// 進むボタン
    var forwardButton: UIBarButtonItem! { get set }
    
    /// 戻るボタンタップイベント
    func didTapBack(_ sender: UIBarButtonItem)
    
    /// 進むボタンタップイベント
    func didTapForward(_ sender: UIBarButtonItem)
    
    /// 更新ボタンタップイベント
    func didTapRefresh(_ sender: UIBarButtonItem)
    
    /// 前のページへ移動可能かどうか
    ///
    /// - Returns: true: 可能, false: 不可
    func isEnabledBack() -> Bool
    
    /// 次のページへ移動可能かどうか
    ///
    /// - Returns: true: 可能, false: 不可
    func isEnabledForward() -> Bool
}
