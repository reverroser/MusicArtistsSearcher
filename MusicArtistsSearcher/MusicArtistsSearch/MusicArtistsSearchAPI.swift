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

    // TODO TEST check if the request returns a list of MusicArtist
    func searchMusicArtists(searchText: String) -> Observable<[MusicArtist]> {
        return Observable<[MusicArtist]>.create { [unowned self] observer in
            self.apiClient.fetch(apiRequest: MusicArtistsSearchRequest(term: searchText.lowercased()))
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
