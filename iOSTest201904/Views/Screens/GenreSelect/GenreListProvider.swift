//
//  GenreListProvider.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

final class GenreListProvider: NSObject {
    
    private(set) var genreList = GenreDao.findAll()
    
    func selectedGenre(indexPath: IndexPath?) -> Genre? {
        guard let indexPath = indexPath else {
            return nil
        }
        return genreList[indexPath.row]
    }
}

extension GenreListProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.genreCellIdentifier, for: indexPath)
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.textLabel?.text = genreList[indexPath.row].name
        return cell
    }
}
