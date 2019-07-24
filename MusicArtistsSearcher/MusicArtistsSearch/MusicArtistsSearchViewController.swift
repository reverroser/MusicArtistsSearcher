//
//  MusicArtistsSearchViewController.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 22/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class MusicArtistsViewController: UIViewController {
    private let tableView = UITableView()
    private let cellIdentifier = "cellIdentifier"
    private let searchApi = MusicArtistsSearchAPI()
    private let disposeBag = DisposeBag()
    let realm = try! Realm()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search music artists"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupLayout()
        setupReactiveBinding()
    }
    
    private func setupProperties() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    private func setupReactiveBinding() {
        searchController.searchBar.rx.text.orEmpty
            .flatMapLatest { text in
                self.searchApi.searchMusicArtists(searchText: text)
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
                cell.textLabel?.text = model.artistName
                cell.detailTextLabel?.text = model.primaryGenreName
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
                let searchTerm = MusicSearchSearchTerm(value: [self.searchController.searchBar.text])
                try! self.realm.write {
                    self.realm.add(searchTerm)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
