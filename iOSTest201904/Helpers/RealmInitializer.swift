//
//  RealmInitializer.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RealmSwift

final class RealmInitializer: RealmInitializeService {
    
    let configuration: Realm.Configuration?
    
    init(configuration: Realm.Configuration? = nil) {
        self.configuration = configuration
    }
    
    func initializeRealm() -> Realm {
        do {
            var realm: Realm
            if let configuration = configuration {
                realm = try Realm(configuration: configuration)
            } else {
                realm = try Realm()
            }
            return realm
            
        } catch {
            fatalError("Realm initialize error: \(error)")
        }
    }
}
