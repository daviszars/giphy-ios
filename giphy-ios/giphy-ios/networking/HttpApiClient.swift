//
//  HttpApiClient.swift
//  giphy-ios
//
//  Created by DavisZ on 14/09/2023.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

final class HttpApiClient {
    static let BASE_URL = "https://api.giphy.com/v1/gifs/"

    static let API_TRENDING = "trending"
    static let API_SEARCH = "search"
    
    private let key = "6Y16z6oQAlxK36BHkK5m1yOcFRPZv91Z"
    private let limit = 25
    
    static let shared = HttpApiClient()
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = TimeInterval(60)
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        
        return Session(
            configuration: configuration
        )
    }()
    
    func getUrl(_ queryPart: String) -> String {
        return HttpApiClient.BASE_URL + queryPart
    }
    
    func getTrendingGifs(offset: Int) -> Single<GiphyResponse> {
        let params: [String : Any] = [
            "offset": offset,
            "limit": self.limit,
            "api_key": self.key
        ]

        return sessionManager.rx.request(.get, getUrl(HttpApiClient.API_TRENDING),
                                         parameters: params,
                                         encoding: URLEncoding())
            .do(onSubscribed: { print("<- making get trending gifs call...") })
            .subscribe(on:ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { request in
                return request.validate().rx.json()
            }
            .asSingle()
            .map { data in
                let json = data as! [String:Any]
                return GiphyResponse(from: json)
            }
            .do(onSuccess: { _ in print("-> got trending gifs response") })
    }
    
    func getGifsBySearch(query: String, offset: Int) -> Single<GiphyResponse> {
        let params: [String : Any] = [
            "q": query,
            "offset": offset,
            "limit": self.limit,
            "api_key": self.key
        ]

        return sessionManager.rx.request(.get, getUrl(HttpApiClient.API_SEARCH),
                                         parameters: params,
                                         encoding: URLEncoding())
            .do(onSubscribed: { print("<- making get gifs by search call...") })
            .subscribe(on:ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { request in
                return request.validate().rx.json()
            }
            .asSingle()
            .map { data in
                let json = data as! [String:Any]
                return GiphyResponse(from: json)
            }
            .do(onSuccess: { _ in print("-> got gifs by search response") })
    }
    
}
