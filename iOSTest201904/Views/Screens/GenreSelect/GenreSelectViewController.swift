//
//  GenreSelectViewController.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

protocol GenreListDelegate: class {
    func selected(genre: Genre)
}

final class GenreSelectViewController: UIViewController {

    @IBOutlet private weak var genreTableView: UITableView!
    private let genreListProvider = GenreListProvider()
    weak var delegate: GenreListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        genreTableView.dataSource = genreListProvider
        genreTableView.allowsMultipleSelection = false
    }
}

extension GenreSelectViewController {
    class func instance(delegate: GenreListDelegate?) -> GenreSelectViewController {
        let vc = GenreSelectViewController.instantiate()
        vc.delegate = delegate
        return vc
    }
}

extension GenreSelectViewController {
    @IBAction func didTapBack(_ sender: UIButton) {
        if let selectedGenre = genreListProvider.selectedGenre(indexPath: genreTableView.indexPathForSelectedRow) {
            delegate?.selected(genre: selectedGenre)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension GenreSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
