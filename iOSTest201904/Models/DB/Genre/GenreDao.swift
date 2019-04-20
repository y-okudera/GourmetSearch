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
