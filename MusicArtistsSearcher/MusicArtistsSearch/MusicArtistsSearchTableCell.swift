//
//  MusicArtistsSearchTableCell.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 23/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
