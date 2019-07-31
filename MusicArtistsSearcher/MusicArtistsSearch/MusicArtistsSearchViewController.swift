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
    
    // Explain why do you think this is good?
    
    private let cellIdentifier = "cellIdentifier"
    // This is fine.
    private var disposeBag = DisposeBag()
    let realm = try! Realm()
    
    
    // This can be lazy loaded since it will affect the preformance of the application
    private lazy var tableView = UITableView()
    private lazy var searchApi = MusicArtistsSearchAPI()
    
    private lazy var searchController: UISearchController = {
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
        // super nice! this can be done without any issues! however if you scroll to the end of the file you will find what can also be done to minimize the amount of code written.
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

        // MARK: - didn't ask for this
        
        // A plus!
        // This observer stores the last search term into RealmDB to allow us to show them in the main screen
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
                let searchTerm = MusicArtistSearchTerm(value: [self.searchController.searchBar.text])
                try! self.realm.write {
                    self.realm.add(searchTerm)
                }
            })
            .disposed(by: self.disposeBag)
        
        // A plus!
        // On cell selected the Artist URL is generated to be opened in the browser
        tableView.rx.modelSelected(MusicArtist.self)
            .subscribe(onNext: { model in
                guard let url = URL(string: model.artistLinkUrl) else { return }
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - just a five min enhancement that you can also consider. This can be used on a singalton instead of the viewcontroller however for the simple implementation i am just leaving it to the class to handle the protocols


extension MusicArtistsViewController: APIClientProtocol {}

extension MusicArtistsViewController: MusicArtistsFetcher {

    func fetch() {
        searchController.searchBar.rx.text.orEmpty
            .flatMapLatest { text in
                self.searchMusicArtists(searchText: text)
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
                cell.textLabel?.text = model.artistName
                cell.detailTextLabel?.text = model.primaryGenreName
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            .disposed(by: disposeBag)

    }
}
