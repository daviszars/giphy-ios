//
//  GifRepository.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation
import RxSwift

class GifRepository {
    static let shared = GifRepository()
    
    func getTrendingGifs(offset: Int) -> Single<GiphyResponse> {
        return HttpApiClient.shared.getTrendingGifs(offset: offset)
            .map { result in
                if result.pagination == nil || result.data == nil {
                    throw GifRepositoryError.badData("Server returned faulty data")
                }
                return result
        }
    }
    
    func getGifsBySearch(query: String, offset: Int) -> Single<GiphyResponse> {
        return HttpApiClient.shared.getGifsBySearch(query: query, offset: offset)
            .map { result in
                if result.pagination == nil || result.data == nil {
                    throw GifRepositoryError.badData("Server returned faulty data")
                }
                return result
        }
    }
}

enum GifRepositoryError: Error {
    case badData(String)
}
