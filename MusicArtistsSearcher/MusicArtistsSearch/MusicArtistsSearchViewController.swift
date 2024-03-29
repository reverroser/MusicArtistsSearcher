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
        navigationItem.title = "Music artists searcher"
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
        
        // This observer stores the last search term into RealmDB to allow us to show them in the main screen
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
                let searchTerm = MusicArtistSearchTerm(value: [self.searchController.searchBar.text])
                try! self.realm.write {
                    self.realm.add(searchTerm)
                }
            })
            .disposed(by: self.disposeBag)
        
        // On cell selected the Artist URL is generated to be opened in the browser
        tableView.rx.modelSelected(MusicArtist.self)
            .subscribe(onNext: { model in
                guard let url = URL(string: model.artistLinkUrl) else { return }
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
    }
}
