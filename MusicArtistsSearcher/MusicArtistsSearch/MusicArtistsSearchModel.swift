//
//  MusicArtistsSearchEntity.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 23/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

import Foundation
import RealmSwift

struct MusicArtist: Codable {
    let artistName: String
    let primaryGenreName: String
    let artistLinkUrl: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? ""
        self.primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? "undefined"
        self.artistLinkUrl = try container.decodeIfPresent(String.self, forKey: .artistLinkUrl) ?? ""
    }
}

class MusicSearchSearchTerm: Object {
    @objc dynamic var term = ""
}
