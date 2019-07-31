//
//  MusicArtistsSearchAPI.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 24/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

import Foundation
import RxSwift

class MusicArtistsSearchAPI {
    let apiClient = APIClient<APIRepsonse<MusicArtist>>()
    private let disposeBag = DisposeBag()

    // The request returns { resultsCount: Int, results: Array }
    func searchMusicArtists(searchText: String) -> Observable<[MusicArtist]> {
        return Observable<[MusicArtist]>.create { [unowned self] observer in
            self.apiClient.send(apiRequest: MusicArtistsSearchRequest(term: searchText.lowercased()))
                .subscribe(
                    onNext: { data in
                        observer.onNext(data.results!)
                    },
                    onError: { error in
                        observer.onError(error)
                    },
                    onCompleted: {
                        observer.onCompleted()
                    }
                )
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

// MARK: - Some implementation that you might consider

enum SomeError: Error {
    case searchError
}

protocol MusicArtistsFetcher {}

extension MusicArtistsFetcher where Self: APIClientProtocol {
    
    func searchMusicArtists(searchText: String) -> Observable<[MusicArtist]> {
        
        // the implemetation i was talking about on the meeting!
        
        return send(apiRequest: MusicArtistsSearchRequest(term: searchText.lowercased()))
            .map { (data: APIRepsonse<MusicArtist>) -> [MusicArtist] in
                guard let result = data.results else {
                    throw SomeError.searchError
                }
                return result
            }.catchErrorJustReturn([])
    }
}
