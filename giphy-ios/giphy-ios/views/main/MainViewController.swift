//
//  MainViewController.swift
//  giphy-ios
//
//  Created by DavisZ on 13/09/2023.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    
    let noResultsMsg = "No results"
    let trendingMsg = "Trending"
    
    let viewModel: MainViewModel = MainViewModel()
    
    private let disposables = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
        initSearch()
    }
    
    func initCollectionView() {
        collectionView?.register(UINib(nibName: "GifCell", bundle: nil), forCellWithReuseIdentifier: "gifCell")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    func initSearch() {
        viewModel.searchQuery
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { query in
                self.viewModel.resetGifList()
                if query.isEmpty {
                    self.refreshTrendingGifs(scrollToTop: true)
                } else {
                    self.refreshSearchGifs(scrollToTop: true, query: query)
                }
            })
            .disposed(by: disposables)
    }
    
    func refreshTrendingGifs(scrollToTop: Bool) {
        viewModel.getTrendingGifs()
            .subscribe(onSuccess: { _ in
                self.collectionView.reloadData()
                self.titleLabel.text = self.trendingMsg
                if scrollToTop {
                    self.collectionView.setContentOffset(.zero, animated: true)
                }
            }).disposed(by: disposables)
    }
    
    func refreshSearchGifs(scrollToTop: Bool, query: String) {
        viewModel.getGifsBySearch(query: query).subscribe(onSuccess: { _ in
            self.collectionView.reloadData()
            self.titleLabel.text = self.viewModel.gifs.isEmpty ? self.noResultsMsg : query
            if scrollToTop {
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }).disposed(by: disposables)
    }

}

//MARK: Collection view delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! GifCell
        
        if viewModel.gifs.isEmpty {
            return cell
        }
        
        cell.display(from: viewModel.gifs[indexPath.row].images.fixedWidth.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Load more items when user scrolls to the last item
        if (indexPath.row == viewModel.gifs.count - 1 ) && (indexPath.row < viewModel.maxGifCount - 1) {
            let searchQuery = try! viewModel.searchQuery.value()
            if searchQuery.isEmpty {
                refreshTrendingGifs(scrollToTop: false)
            } else {
                refreshSearchGifs(scrollToTop: false, query: searchQuery)
            }
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.gifs.isEmpty {
            return
        }
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        controller.display(from: viewModel.gifs[indexPath.row].images.original)

        self.present(controller, animated: true)
    }
}

//MARK: Collection view layout
extension MainViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
            return CGFloat(viewModel.gifs[indexPath.item].images.fixedWidth.height)
    }
}

//MARK: Search bar
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.searchQuery.onNext("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery.onNext(searchText)
    }
}
