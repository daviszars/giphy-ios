//
//  MainViewModel.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation
import RxSwift

class MainViewModel {
    let searchQuery: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var gifs: [Gif] = []
    var maxGifCount: Int = 0

    func getTrendingGifs() -> Single<GiphyResponse> {
        return GifRepository.shared.getTrendingGifs(offset: gifs.count).do(onSuccess:{ response in
            self.gifs.append(contentsOf: response.data ?? [])
            self.maxGifCount = response.pagination?.totalCount ?? 0
        }, onError: { err in
            print(err.localizedDescription)
        })
    }
    
    func getGifsBySearch(query: String) -> Single<GiphyResponse> {
        return GifRepository.shared.getGifsBySearch(query: query, offset: gifs.count).do(onSuccess:{ response in
            self.gifs.append(contentsOf: response.data ?? [])
            self.maxGifCount = response.pagination?.totalCount ?? 0
        }, onError: { err in
            print(err.localizedDescription)
        })
    }
    
    func resetGifList() {
        gifs = []
        maxGifCount = 0
    }
}
