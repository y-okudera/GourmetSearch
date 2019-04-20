//
//  RestaurantDetailViewController.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import MessageUI
import UIKit
import WebKit

final class RestaurantDetailViewController: UIViewController {

    let activityIndicator = UIActivityIndicatorView()
    let defaultURL = WebViewConstants.baseURL
    var baseURL: String?
    private var name = ""
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        navigationItem.title = self.name
        hideNavigationBarBackTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func didTapForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func didTapRefresh(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    // MARK: - Private
    
    /// WebViewの初期処理
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        let urlString = baseURL ?? defaultURL
        loadWeb(urlString: urlString)
    }
    
    /// WebViewのロード処理
    private func loadWeb(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension RestaurantDetailViewController {
    class func instance(name: String, baseURL: String?) -> RestaurantDetailViewController {
        let vc = RestaurantDetailViewController.instantiate()
        vc.baseURL = baseURL
        vc.name = name
        return vc
    }
}

// MARK: - WebViewControllerCompatible
extension RestaurantDetailViewController: WebViewControllerCompatible {
    
    func didChangeLoadingStatus(status: WebLoadingStatus) {
        
        switch status {
        case .started:
            showIndicator()
            
        case .finished:
            backButton.isEnabled = isEnabledBack()
            forwardButton.isEnabled = isEnabledForward()
            hideIndicator()
            
        case .occurredError(let error):
            print("WebLoadingStatus: \(status) Error: \(error)")
            
            backButton.isEnabled = isEnabledBack()
            forwardButton.isEnabled = isEnabledForward()
            hideIndicator()
            
            guard let urlError = error as? URLError else {
                return
            }
            let isOffline = urlError.code == URLError.notConnectedToInternet
            let isTimeout = urlError.code == URLError.timedOut
            if isOffline || isTimeout {
                showConnectionErrorAlert()
            }
        }
    }
    
    func showConnectionErrorAlert() {
        let connectionErrorTitle = "通信エラー"
        let connectionErrorMSG = "通信エラーが発生しました。\nネットワーク状況を確認して\n再度お試しください。"
        showAlert(title: connectionErrorTitle, message: connectionErrorMSG)
    }
    
    func jsAlert(alertController: UIAlertController) {
        hideIndicator()
        present(alertController, animated: true, completion: nil)
    }
    
    func sendMail(mailScheme: MailScheme) {
        if let mfMailComposeVC = MailLauncher.sendMail(mailScheme: mailScheme, delegate: self) {
            present(mfMailComposeVC, animated: true, completion: nil)
        }
    }
    
    func openSafari(url: URL) {
        let title = "確認"
        let message = "ブラウザを起動してWebページを表示します。よろしいですか？"
        showAlert(title: title, message: message) { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension RestaurantDetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WebViewToolBarCompatible
extension RestaurantDetailViewController: WebViewToolBarCompatible {
    
    func isEnabledBack() -> Bool {
        return webView.canGoBack
    }
    
    func isEnabledForward() -> Bool {
        return webView.canGoForward
    }
}

// MARK: - IndicatorPresenter
extension RestaurantDetailViewController: IndicatorPresenter {}
