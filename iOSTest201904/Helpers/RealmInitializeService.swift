//
//  RealmInitializeService.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RealmSwift

protocol RealmInitializeService {
    var configuration: Realm.Configuration? { get }
    func initializeRealm() -> Realm
}
