//
//  APICLient.swift
//  MusicArtistsSearcher
//
//  Created by Roser Reverte Avila on 23/07/2019.
//  Copyright © 2019 Roser Reverte Avila. All rights reserved.
//

import Foundation
import RxSwift

class APIClient<T: Decodable> {
    private let baseURL = URL(string: "https://itunes.apple.com/")!
    
    func fetch(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            print(request)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    guard let data = data, data.count > 0 else { return }
                    let model: T = try JSONDecoder().decode(T.self, from: data )
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
