//
//  GifCell.swift
//  giphy-ios
//
//  Created by DavisZ on 17/09/2023.
//

import UIKit
import Nuke
import NukeUI

class GifCell: UICollectionViewCell {
    let lazyImageView = LazyImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lazyImageView.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lazyImageView.reset()
    }
    
    func setup() {
        lazyImageView.placeholderView = UIActivityIndicatorView()
        backgroundColor = .secondarySystemBackground
        
        addSubview(lazyImageView)
    }
    
    func display(from url: String) {
        lazyImageView.url = URL(string: url)
    }

}
