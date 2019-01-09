//
//  ViewController.swift
//  MovieApp
//
//  Created by Ketan on 1/3/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListVC: UIViewController {
    
    //MARK:- IBOutlate
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var viewMovieDetail: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK:- Variables
    
    //List of all movies
    private var movieObjects = [MovieObject]()
    
    private var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! MovieFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    //MARK:- Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllMoviewsFromServer()
    }
    
    //MARK:- Get all Movie list
    
    private func getAllMoviewsFromServer() {
        
        let movieModel = MovieModel()
        movieModel.getAllMoviesFromServer(dictParams: nil, success: { (response) in
            
            self.movieObjects = response as! [MovieObject]
            
            if(self.movieObjects.count > 0) {
                DispatchQueue.main.async {
                    self.collectionView.isHidden = false
                    self.viewMovieDetail.isHidden = false
                    self.activity.isHidden = true
                    self.setMovieDetails(currentPage: 0)
                    self.collectionView.reloadData()
                }
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                self.activity.isHidden = true
            }
        }
        
    }
    
    //MARK:- Custom methods
    
    private func setMovieDetails(currentPage: Int) {
        
        let movieModel = self.movieObjects[currentPage]
        
        UIView.transition(with: self.infoLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.infoLabel.text = movieModel.strTitle
            self.detailLabel.text = movieModel.strType
        })
    }
    
}


// MARK: - Collection Delegate & DataSource
extension MovieListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieModel = movieObjects[(indexPath as NSIndexPath).row]
        cell.lblPreSale.isHidden = movieModel.isPreSeal!
        cell.ivImage.sd_setImage(with: movieModel.urlImagePath, completed: nil)
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
