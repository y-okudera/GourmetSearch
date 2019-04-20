//
//  GenreDao.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

final class GenreDao {
    
    static let dao = RealmDaoHelper<GenreAPIResponse>()
    
    static func add(genreApiResponse: GenreAPIResponse) {
        dao.deleteAll()
        dao.add(object: genreApiResponse)
    }
    
    static func findAll() -> [Genre] {
        var genreList = [Genre]()
        let genreDao = RealmDaoHelper<Genre>()
        for object in genreDao.findAll() {
            let genre = Genre(value: object)
            genreList.append(genre)
        }
        return genreList
    }
}
//
//// MARK: - プロフィール情報
//extension GenreDao {
//
//    /// 現在ログインしているユーザのフラグをスキップ済みにする
//    static func updateSkipped() {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return
//        }
//        let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//        do {
//            try dao.realm.write {
//                fetchResult?.skipped = true
//            }
//        } catch {
//            log?.error(error)
//        }
//    }
//
//    /// 現在ログインしているユーザがプロフィール登録スキップ済みかどうかのフラグを取得する
//    static func isSkipped() -> Bool {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return false
//        }
//        let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//        guard let result = fetchResult?.skipped else {
//            return false
//        }
//        return result
//    }
//
//    /// 現在ログインしているユーザのプロフィールが存在するか(姓、名が既に登録されているかどうか)
//    static func existsLoginUserProfile() -> Bool {
//        guard let myProfile = findMyProfile() else {
//            return false
//        }
//        guard let sei = myProfile.sei, let mei = myProfile.mei else {
//            return false
//        }
//        if sei.isEmpty || mei.isEmpty {
//            return false
//        }
//        return true
//    }
//
//    /// 現在ログインしているユーザのプロフィールを取得
//    static func findMyProfile() -> Profile? {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return nil
//        }
//        let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//        guard let result = fetchResult?.profile else {
//            return nil
//        }
//        let myProfile = Profile(
//            sei: result.sei,
//            mei: result.mei,
//            seikana: result.seikana,
//            meikana: result.meikana,
//            bizcompname: result.bizcompname,
//            bizsectionname: result.bizsectionname,
//            bizpost: result.bizpost,
//            biztel: result.biztel,
//            biztel2: result.biztel2,
//            fax: result.fax,
//            mobile: result.mobile,
//            bizmail: result.bizmail,
//            bizmail2: result.bizmail2,
//            url: result.url,
//            url2: result.url2,
//            zip: result.zip,
//            state: result.state,
//            bizaddr: result.bizaddr,
//            bldg: result.bldg,
//            idimgf: result.idimgf,
//            idimgb: result.idimgb,
//            updateDate: result.updateDate
//        )
//        return myProfile
//    }
//}
//
//// MARK: - プロフィール未送信商談データ
//extension UserEntityDao {
//
//    /// 現在ログインしているユーザの未送信商談データを追加する
//    static func updateUnsentProjects(opportunity: Opportunity) {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return
//        }
//
//        let unsentProjectNewId = RealmDaoHelper<UnsentProjectEntity>().newId() ?? 0
//
//        guard let fetchResult = dao.findFirst(key: loginUserId as AnyObject) else {
//            return
//        }
//
//        let unsentProject = UnsentProjectEntity(opportunity: opportunity, newId: unsentProjectNewId)
//        do {
//            try dao.realm.write {
//                fetchResult.unsentProjects.append(unsentProject)
//            }
//        } catch {
//            log?.error(error)
//        }
//    }
//
//    /// 現在ログインしているユーザの未送信商談情報を取得する
//    static func findUnsentProjects() -> [UnsentProjectEntity]? {
//
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return nil
//        }
//        let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//        guard let result = fetchResult?.unsentProjects else {
//            return nil
//        }
//
//        var unsentProjectEntities = [UnsentProjectEntity]()
//        for unsentProject in result {
//            unsentProjectEntities.append(UnsentProjectEntity(value: unsentProject))
//        }
//        return unsentProjectEntities
//    }
//
//    /// 現在ログインしているユーザの未送信商談情報を削除する
//    static func deleteUnsentProjects() {
//        let unsentProjectDAO = RealmDaoHelper<UnsentProjectEntity>()
//        let userId = UserDefaults.standard.string(forKey: .loginUserId) ?? ""
//        let predicate = NSPredicate(format: "userId = %@", userId)
//        let objects = unsentProjectDAO.filter(predicate: predicate)
//        unsentProjectDAO.delete(objects: Array(objects))
//    }
//
//    /// 現在ログインしているユーザの未送信商談情報の件数を取得する
//    static func unsentProjectsCount() -> Int {
//        return findUnsentProjects()?.count ?? 0
//    }
//}
//
//// MARK: - プロフィール未送信名刺データ
//extension UserEntityDao {
//
//    /// 現在ログインしているユーザの未送信名刺データを追加する
//    static func updateUnsentCards(unsentCardEntity: UnsentCardEntity) {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return
//        }
//
//        let unsentCardNewId = RealmDaoHelper<UnsentCardEntity>().newId() ?? 0
//
//        guard let fetchResult = dao.findFirst(key: loginUserId as AnyObject) else {
//            return
//        }
//
//        unsentCardEntity.id = unsentCardNewId
//        do {
//            try dao.realm.write {
//                fetchResult.unsentCards.append(unsentCardEntity)
//            }
//        } catch {
//            log?.error(error)
//        }
//    }
//
//    /// 現在ログインしているユーザの未送信名刺データを削除する
//    /// ログインユーザに紐づく未送信名刺情報を削除する
//    static func deleteUnsentCards() {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return
//        }
//
//        let unsentCardEntityDAO = RealmDaoHelper<UnsentCardEntity>()
//        let predicate = NSPredicate(format: "userId = %@", loginUserId)
//        let objects = unsentCardEntityDAO.filter(predicate: predicate)
//        unsentCardEntityDAO.delete(objects: Array(objects))
//    }
//
//    /// 現在ログインしているユーザの未送信名刺データを取得する
//    static func findUnsentCards() -> [UnsentCardEntity]? {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return nil
//        }
//        let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//        guard let result = fetchResult?.unsentCards else {
//            return nil
//        }
//
//        var unsentCardEntities = [UnsentCardEntity]()
//        for unsentCard in result {
//            unsentCardEntities.append(UnsentCardEntity(value: unsentCard))
//        }
//        return unsentCardEntities
//    }
//
//    /// 現在ログインしているユーザの未送信名刺データの件数を取得する
//    static func unsentCardsCount() -> Int {
//        return findUnsentCards()?.count ?? 0
//    }
//}
//
//// MARK: - メモ(人物情報画面)
//extension UserEntityDao {
//
//    /// 現在ログインしているユーザが保持する名刺に紐づくメモを追加する
//    static func updateMemos(memoEntity: MemoEntity) {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return
//        }
//
//        let memoEntityDAO = RealmDaoHelper<MemoEntity>()
//        if let result = memoManagedObject(cardId: memoEntity.cardId, memoEntityDAO: memoEntityDAO) {
//
//            do {
//                try memoEntityDAO.realm.write {
//                    result.memo = memoEntity.memo
//                }
//            } catch {
//                log?.error(error)
//            }
//        } else {
//
//            // 新規追加する
//            let memoNewId = RealmDaoHelper<MemoEntity>().newId() ?? 0
//            memoEntity.id = memoNewId
//
//            let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//            do {
//                try dao.realm.write {
//                    fetchResult?.memos.append(memoEntity)
//                }
//            } catch {
//                log?.error(error)
//            }
//        }
//    }
//
//    /// 現在ログインしているユーザが保持する名刺のうち、指定cardIdの名刺に紐づくメモを取得する
//    static func findMemo(cardId: Int) -> MemoEntity? {
//        guard let fetchResult = memoManagedObject(cardId: cardId) else {
//            return nil
//        }
//        return MemoEntity(value: fetchResult)
//    }
//
//    /// 現在ログインしているユーザが保持する名刺のうち、指定cardIdの名刺に紐づくメモのRealm Managed Objectを取得する
//    private static func memoManagedObject(cardId: Int, memoEntityDAO: RealmDaoHelper<MemoEntity>? = nil) -> MemoEntity? {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return nil
//        }
//
//        let memoEntityDAO = memoEntityDAO ?? RealmDaoHelper<MemoEntity>()
//        let predicate = NSPredicate(format: "userId = %@ AND cardId = \(cardId)", loginUserId)
//
//        guard let fetchResult = memoEntityDAO.filter(predicate: predicate).first else {
//            return nil
//        }
//        return fetchResult
//    }
//}
//
//extension UserEntityDao {
//
//    /// 現在ログインしているユーザが保持する最新ニュースのIDを追加する
//    static func updateLatestNewsDocId(latestNewsId: Int) {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return
//        }
//        let fetchResult = dao.findFirst(key: loginUserId as AnyObject)
//        do {
//            try dao.realm.write {
//                fetchResult?.latestNewsDocId = latestNewsId
//            }
//        } catch {
//            log?.error(error)
//        }
//    }
//
//    /// 現在ログインしているユーザが保持する最新ニュースのIDを取得する
//    static func findLatestNewsDocId() -> Int {
//        guard let loginUserId = UserDefaults.standard.string(forKey: .loginUserId) else {
//            return 0
//        }
//        guard let fetchResult = dao.findFirst(key: loginUserId as AnyObject) else {
//            return 0
//        }
//        return fetchResult.latestNewsDocId
//    }
//}
