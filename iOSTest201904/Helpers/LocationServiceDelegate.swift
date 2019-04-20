//
//  LocationServiceDelegate.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import CoreLocation
import Foundation

/// 位置情報・方位情報の更新を通知するデリゲートプロトコル
protocol LocationServiceDelegate: class {
    /// 位置情報が許可されていない場合のアラート表示
    func showAppSettingAlert()
    /// 位置情報更新
    func update(coordinate: CLLocationCoordinate2D)
    /// 方位情報更新
    func update(direction: Int)
}

extension LocationServiceDelegate {
    func update(direction: Int) {}
}
