//
//  MusicArtistSearchAPI.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 23/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

import Foundation
import RxSwift

// This class builds the request for the search
class MusicArtistsSearchRequest: APIRequest {
    var method = RequestType.GET
    var path = "search"
    var parameters = [String: String]()
    
    init(term: String) {
        parameters["entity"] = "musicArtist"
        parameters["term"] = term
    }
}
