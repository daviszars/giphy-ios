//
//  GifDetails.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation

struct GifDetails {
    let url: String
    let height: Int
    let width: Int
    
    init(from json: [String:Any]) {
        url = json["url"] as! String
        height = safeGetInt(json["height"] as AnyObject)!
        width = safeGetInt(json["width"] as AnyObject)!
    }
}
