//
//  Gif.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation

struct Gif {
    let images: Images
    
    init(from json: [String:Any]) {
        images = Images(from: json["images"] as! [String : Any])
    }
}
