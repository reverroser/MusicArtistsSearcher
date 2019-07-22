//
//  MusicArtistsSearchViewController.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 22/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//
import UIKit

class MusicArtistsViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var artistsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
}
