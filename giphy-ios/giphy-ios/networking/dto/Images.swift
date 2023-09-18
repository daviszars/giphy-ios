//
//  Images.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation

struct Images {
    let original: GifDetails
    let fixedWidth: GifDetails
    
    init(from json: [String:Any]) {
        original = GifDetails(from: json["original"] as! [String : Any])
        fixedWidth = GifDetails(from: json["fixed_width"] as! [String : Any])
    }
}
