//
//  RealmDaoHelper.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RealmSwift
import UIKit

/// Realmのヘルパークラス
final class RealmDaoHelper <T: RealmSwift.Object> {
    
    var realm: Realm
    
    init() {
        defer {
            realm.invalidate()
        }
        
        let realmConfiguration = Realm.Configuration(fileURL: RealmDaoHelper.fileURL())
        let realmInitializer = RealmInitializer(configuration: realmConfiguration)
        self.realm = realmInitializer.initializeRealm()
        print(debug: Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    /// 新規主キーを発行する
    ///
    /// - Returns: 新規主キー
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            print(debug: "primaryKey未設定")
            return nil
        }
        return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
    }
    
    /// レコードを全件取得する
    ///
    /// - Returns: 取得結果
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /// 1件目のレコードのみ取得する
    ///
    /// - Returns: 取得結果
    func findFirst() -> T? {
        return findAll().first
    }
    
    /// 指定キーのレコードを取得する
    ///
    /// - Parameter key: キー
    /// - Returns: 取得結果
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /// 最後のレコードを取得する
    ///
    /// - Returns: 取得結果
    func findLast() -> T? {
        return findAll().last
    }
    
    /// 指定条件でレコードを抽出する
    ///
    /// - Parameter predicate: 抽出条件
    /// - Returns: 取得結果
    func filter(predicate: NSPredicate) -> Results<T> {
        return realm.objects(T.self).filter(predicate)
    }
    
    /// レコードを追加する
    ///
    /// - Parameter object: 追加するレコード
    func add(object: T) {
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch let error {
            print(debug: error.localizedDescription)
        }
    }
    
    /// 複数件のレコードを追加する
    ///
    /// - Parameter objects: 追加するレコードの配列
    func add(objects: [T]) {
        do {
            try realm.write {
                realm.add(objects, update: true)
            }
        } catch let error {
            print(debug: error.localizedDescription)
        }
    }
    
    /// レコード更新する
    ///
    /// - Warning: T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
    ///
    /// - Parameters:
    ///   - object: 更新するレコードのオブジェクト
    ///   - block: アップデートブロック
    /// - Returns: 更新結果
    ///
    @discardableResult
    func update(object: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(object, update: true)
            }
            return true
        } catch let error {
            print(debug: error.localizedDescription)
        }
        return false
    }
    
    /// 複数件のレコードを更新する
    ///
    /// - Parameters:
    ///   - objects: 更新するレコードの配列
    ///   - block: アップデートブロック
    /// - Returns: 更新結果
    @discardableResult
    func update(objects: [T], block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(objects, update: true)
            }
            return true
        } catch let error {
            print(debug: error.localizedDescription)
        }
        return false
    }
    
    /// レコードを削除する
    ///
    /// - Parameter object: 削除するレコード
    func delete(object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print(debug: error.localizedDescription)
        }
    }
    
    /// レコードを複数件削除する
    ///
    /// - Parameter objects: 削除するレコードの配列
    func delete(objects: [T]) {
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch let error {
            print(debug: error.localizedDescription)
        }
    }
    
    /// レコードを全件削除する
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error {
            print(debug: error.localizedDescription)
        }
    }
}

extension RealmDaoHelper {
    /// RealmファイルのURLを取得する
    private static func fileURL() -> URL? {
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first else {
                return nil
        }
        var filePath = documentDirectory
        
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            filePath.append("/\(Constants.dbName)")
        } else {
            filePath.append("/test.realm")
        }
        return URL(string: filePath)
    }
}
