//
//  SearchRequestTests.swift
//  SearchRequestTests
//
//  Created by Roser Reverte Avila on 22/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

import XCTest
@testable import MusicArtistsSearcher

class SearchRequestTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testMusicArtistsSearchRequest() {
        let apiRequest = MusicArtistsSearchRequest(term: "a")
        let baseURL = URL(string: "https://itunes.apple.com/")!
        let request = apiRequest.request(with: baseURL)
        XCTAssertEqual(request.url, URL(string: "https://itunes.apple.com/search?entity=musicArtist&term=a"))
    }
}
