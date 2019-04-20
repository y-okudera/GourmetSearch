//
//  AlertBuilder.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

struct AlertBuilder {
    typealias ActionHandler = ((UIAlertAction) -> Void)?
    
    /// ボタン1つのアラートを取得する
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - btnTitle: ボタンのタイトル
    ///   - handler: ボタンタップ時のハンドラ
    /// - Returns: UIAlertControllerオブジェクト
    static func singleButtonAlert(title: String,
                                  message: String,
                                  btnTitle: String = "OK",
                                  handler: ActionHandler = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: btnTitle, style: .default, handler: handler))
        return alert
    }
    
    /// ボタン2つのアラートを取得する
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - rightBtnTitle: 右のボタンのタイトル
    ///   - cancelBtnTitle: キャンセルボタン(左のボタン)のタイトル
    ///   - rightBtnHandler: 右のボタンのハンドラ
    ///   - cancelBtnHandler: キャンセルボタンのハンドラ
    /// - Returns: UIAlertControllerオブジェクト
    static func doubleButtonAlert(title: String,
                                  message: String,
                                  rightBtnTitle: String = "OK",
                                  cancelBtnTitle: String = "キャンセル",
                                  rightBtnHandler: ActionHandler,
                                  cancelBtnHandler: ActionHandler = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: rightBtnTitle, style: .default, handler: rightBtnHandler))
        alert.addAction(.init(title: cancelBtnTitle, style: .cancel, handler: cancelBtnHandler))
        return alert
    }
}
