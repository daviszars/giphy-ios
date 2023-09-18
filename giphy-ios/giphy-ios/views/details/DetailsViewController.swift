//
//  DetailsViewController.swift
//  giphy-ios
//
//  Created by DavisZ on 18/09/2023.
//

import UIKit
import Nuke
import NukeUI

class DetailsViewController: UIViewController {
    let lazyImageView = LazyImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func setup() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        lazyImageView.placeholderView = UIActivityIndicatorView()
        view.addSubview(lazyImageView)
    }
    
    func display(from gifDetails: GifDetails) {
        lazyImageView.url = URL(string: gifDetails.url)
        
        let screenWidth = Int(view.bounds.width)
        let screenHeight = Int(view.bounds.height)
        let height = (gifDetails.height * screenWidth) / gifDetails.width
        let centerY = (screenHeight / 2) - (height / 2)

        lazyImageView.frame = CGRect(x: 0, y: centerY, width: screenWidth, height: height)
    }
    
}
