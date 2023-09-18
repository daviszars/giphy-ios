//
//  GiphyResponse.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation

struct GiphyResponse {
    let data: [Gif]?
    let pagination: Pagination?

    init(from json: [String:Any]) {
        
        if let dataJson = json["data"] as? [[String:Any]] {
            data = dataJson.map { gifs in Gif(from: gifs) }
        } else {
            data = nil
        }
        
        if let paginationJson = json["pagination"] as? [String:Any] {
            pagination = Pagination(from: paginationJson)
        } else {
            pagination = nil
        }
        
    }
}
