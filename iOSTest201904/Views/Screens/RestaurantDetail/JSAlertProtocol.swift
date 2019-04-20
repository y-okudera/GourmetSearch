//
//  JSAlertProtocol.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

protocol JSAlertProtocol where Self: UIViewController {
    
    /// OKボタンのみのアラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - handler: OKボタンタップ後の処理
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?)
    
    /// OK/Cancelボタンを持つアラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - positiveHandler: OKボタンタップ後の処理
    ///   - negativeHandler: Cancelボタンタップ後の処理
    func showConfirm(title: String, message: String,
                     positiveHandler: ((UIAlertAction) -> Void)?,
                     negativeHandler: ((UIAlertAction) -> Void)?)
    
    /// TextFieldを持つアラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - promptMessage: アラートのメッセージ
    ///   - defaultText: デフォルト入力文字列
    ///   - completionHandler: OK/Cancelボタンタップ後の処理
    func showPrompt(title: String,
                    promptMessage: String,
                    defaultText: String?,
                    completionHandler: @escaping (String) -> Void)
}
