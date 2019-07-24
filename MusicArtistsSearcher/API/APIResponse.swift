//
//  APIResponseModel.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 24/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

struct APIRepsonse<T: Codable>: Decodable {
    var resultsCount: Int?
    var results: [T]?
}

