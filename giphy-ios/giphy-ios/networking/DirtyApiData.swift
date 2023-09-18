//
//  DirtyApiData.swift
//  giphy-ios
//
//  Created by DavisZ on 15/09/2023.
//

import Foundation

func safeGetInt(_ value: AnyObject?) -> Int? {
    if let tVal = value as? Int {
        return tVal
    } else if let stringVal = value as? String {
        return Int(stringVal)
    }
    
    return nil
}
