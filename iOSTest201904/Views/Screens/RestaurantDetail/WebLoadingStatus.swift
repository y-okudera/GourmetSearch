//
//  WebLoadingStatus.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

/// 読み込み状況
///
/// - started: 読み込み開始
/// - finished: 読み込み完了
/// - occurredError: エラー発生
enum WebLoadingStatus {
    case started
    case finished
    case occurredError(Error)
}
