//
//  LocationService.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import CoreLocation
import UIKit

final class LocationService: NSObject {
    
    private struct LocationServiceConst {
        static let distanceFilter: CLLocationDistance = kCLDistanceFilterNone
        static let activityType: CLActivityType = .fitness
        static let desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    }
    
    static let shared = LocationService()
    /// 最終更新日時
    static var lastUpdatedDate: Date?
    /// 更新間隔
    private let updateTimeInterval = TimeInterval(3.0)
    private let locationManager = CLLocationManager()
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    /// LocationManagerの起動処理
    func setupLocationManager() {
        locationManager.delegate = self
        if !authorized() {
            delegate?.showAppSettingAlert()
            return
        }
        locationManager.distanceFilter = LocationServiceConst.distanceFilter
        locationManager.activityType = LocationServiceConst.activityType
        locationManager.desiredAccuracy = LocationServiceConst.desiredAccuracy
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    /// LocationManagerの終了処理
    func tearDownLocationManager() {
        locationManager.delegate = nil
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
        if CLLocationManager.headingAvailable() {
            locationManager.stopUpdatingHeading()
        }
    }
}

extension LocationService {
    
    /// 位置情報の利用が許可されているかどうか
    ///
    /// - Returns: true: 許可されている, false: 許可されていない
    private func authorized() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        /// 未設定
        case .notDetermined:
            print("未設定")
            return false
        /// 「機能制限」で位置情報サービスの利用が制限されている
        case .restricted:
            print("「機能制限」で位置情報サービスの利用が制限されている")
            return false
        /// 許可しない
        case .denied:
            print("許可しない")
            return false
        /// このAppの使用中のみ許可
        case .authorizedWhenInUse:
            print("このAppの使用中のみ許可")
            return true
        /// 常に許可
        case .authorizedAlways:
            print("常に許可")
            return true
        }
    }
}

extension LocationService {
    
    /// 現在地の緯度経度とターゲットの緯度経度との方位差おｗ取得する
    func angle(currentLatitude: CGFloat,
               currentLongitude: CGFloat,
               targetLatitude: CGFloat,
               targetLongitude: CGFloat) -> Int {
        
        let currentLatitude = toRadian(currentLatitude)
        let currentLongitude = toRadian(currentLongitude)
        let targetLatitude = toRadian(targetLatitude)
        let targetLongitude = toRadian(targetLongitude)
        
        let difLongitude = targetLongitude - currentLongitude
        let y = sin(difLongitude)
        let x = cos(currentLatitude) * tan(targetLatitude) - sin(currentLatitude) * cos(difLongitude)
        let p = atan2(y, x) * 180 / .pi
        
        if p < 0 {
            return Int(360 + atan2(y, x) * 180 / .pi)
        }
        return Int(atan2(y, x) * 180 / .pi)
    }
    
    /// 自分の座標、角度、距離からターゲットの座標を算出する
    func coordinate(angle: Double, distance: Double) -> CLLocationCoordinate2D {
        let radian = angle * .pi / 180.0
        return CLLocationCoordinate2D(
            latitude: cos(radian) * distance,
            longitude: sin(radian) * distance
        )
    }
    
    /// 角度(°)からラジアンに変換する
    private func toRadian(_ angle: CGFloat) -> CGFloat {
        return angle * .pi / 180
    }
}

// MARK:- CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newLocation = locations.last {
            if filterLocation(newLocation) {
                let roundDownLat = newLocation.coordinate.roundDownLat
                let roundDownLon = newLocation.coordinate.roundDownLon
                let roundDownLocation = CLLocation(latitude: roundDownLat, longitude: roundDownLon)
                delegate?.update(coordinate: roundDownLocation.coordinate)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // タイムインターバル制御
        if timeintervalForHeading() {
            // 向き更新
            let newHeadingIntVal = Int(newHeading.magneticHeading)
            delegate?.update(direction: newHeadingIntVal)
        }
        delegate?.update(direction: Int(newHeading.magneticHeading))
    }
    
    private func filterLocation(_ location: CLLocation) -> Bool {
        
        let age = -location.timestamp.timeIntervalSinceNow
        if age > 10 {
            return false
        }
        if location.horizontalAccuracy < 0 {
            return false
        }
        if location.horizontalAccuracy > 100 {
            return false
        }
        // タイムインターバル制御
        return timeintervalForLocation()
    }
    
    /// 位置情報のインターバルチェック
    private func timeintervalForLocation() -> Bool {
        let now = Date()
        if let lastUpdatedDate = LocationService.lastUpdatedDate {
            
            let timeIntervalSinceLastUpdated = now.timeIntervalSince(lastUpdatedDate)
            
            // インターバルチェック
            if timeIntervalSinceLastUpdated < self.updateTimeInterval {
                return false
            }
        }
        
        // 位置情報を更新する場合は、最終更新日時に現在時刻をセットする
        LocationService.lastUpdatedDate = now
        return true
    }
    
    /// 方位情報のインターバルチェック
    private func timeintervalForHeading() -> Bool {
        let now = Date()
        if let lastUpdatedDate = LocationService.lastUpdatedDate {
            
            let timeIntervalSinceLastUpdated = now.timeIntervalSince(lastUpdatedDate)
            
            // インターバルチェック
            if timeIntervalSinceLastUpdated < self.updateTimeInterval {
                return false
            }
        }
        // 方位情報を更新する場合は、最終更新日時を更新しない
        
        return true
    }
}

extension CLLocationCoordinate2D {
    var roundDownLat: CLLocationDegrees {
        let lat = self.latitude * 1_000_000
        return floor(lat) / 1_000_000
    }
    
    var roundDownLon: CLLocationDegrees {
        let lon = self.longitude * 1_000_000
        return floor(lon) / 1_000_000
    }
}
