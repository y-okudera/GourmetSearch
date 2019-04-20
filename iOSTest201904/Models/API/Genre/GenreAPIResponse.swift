//
//  GenreAPIResponse.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class GenreAPIResponse: Object, Decodable {
    @objc dynamic var id: String?
    @objc dynamic var results: GenreResults?// = GenreResults()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init() {
        super.init()
    }
    
    required init(value: GenreAPIResponse) {
        super.init()
        results = value.results
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

final class GenreResults: Object, Decodable {
    @objc dynamic var apiVersion = ""
    @objc dynamic var resultsReturned = ""
    @objc dynamic var resultsStart = 0
    @objc dynamic var resultsAvailable = 0
    let genre = List<Genre>()
    
    private enum GenreResultsKeys: String, CodingKey {
        case apiVersion
        case resultsReturned
        case resultsStart
        case resultsAvailable
        case genre
    }
    
    convenience init(apiVersion: String,
                     resultsReturned: String,
                     resultsStart: Int,
                     resultsAvailable: Int,
                     genre: [Genre]) {
        self.init()
        self.apiVersion = apiVersion
        self.resultsReturned = resultsReturned
        self.resultsStart = resultsStart
        self.resultsAvailable = resultsAvailable
        self.genre.append(objectsIn: genre)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: GenreResultsKeys.self)
        self.apiVersion = try container.decode(String.self, forKey: .apiVersion)
        self.resultsReturned = try container.decode(String.self, forKey: .resultsReturned)
        self.resultsStart = try container.decode(Int.self, forKey: .resultsStart)
        self.resultsAvailable = try container.decode(Int.self, forKey: .resultsAvailable)
        let genre = try container.decode(List<Genre>.self, forKey: .genre)
        self.genre.append(objectsIn: genre)
    }
}

final class Genre: Object, Decodable {
    @objc dynamic var code = ""
    @objc dynamic var name = ""
    
    required init() {
        super.init()
    }
    
    required init(value: Genre) {
        super.init()
        code = value.code
        name = value.name
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
