//
//  ViewController.swift
//  MovieApp
//
//  Created by Ketan on 1/3/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MovieListVC: UIViewController {
    
    //MARK:- IBOutlate
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewMovieDetail: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK:- Variables
    let disposeBag = DisposeBag()
    private let movieViewModel = MovieViewModel()
    private var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! MovieFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    //MARK:- Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialSetup()
        
        self.movieViewModel.movieObjects.asObservable().subscribe({
            _ in
            
            if(!(self.movieViewModel.movieObjects.value.isEmpty)) {
                
                DispatchQueue.main.async {
                    self.collectionView.isHidden = false
                    self.viewMovieDetail.isHidden = false
                    self.activity.isHidden = true
                    self.setMovieDetails(currentPage: 0)
                    self.collectionView.reloadData()
                }
            }
        } ).disposed(by: disposeBag)
    }
    
    //MARK:- Initial Setup
    
    private func setInitialSetup() {
        collectionView.registerNib("MovieCell")
        self.getAllMoviewsFromServer()
    }
    
    //MARK:- Get all Movie list
    
    private func getAllMoviewsFromServer() {
        movieViewModel.getAllMoviesFromServer()
    }
    
    //MARK:- Custom methods
    
    private func setMovieDetails(currentPage: Int) {
        
        let movieObject = self.movieViewModel.movieObjects.value[currentPage]
        
        UIView.transition(with: self.infoLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.infoLabel.text = movieObject.strTitle
            self.detailLabel.text = movieObject.strType
        })
    }
    
}

// MARK: - Collection Delegate & DataSource
extension MovieListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieViewModel.movieObjects.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movieObject = self.movieViewModel.movieObjects.value[(indexPath as NSIndexPath).row]
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        self.setMovieDetails(currentPage: currentPage)
    }
}
