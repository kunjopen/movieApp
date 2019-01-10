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
        self.bindList()
        self.bindLoading()
    }
    
    //MARK:- UI Binding
    
    private func bindList() {
        
        self.movieViewModel.movieObjects.asObservable()
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
                cell.movieObject = element
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.didEndDecelerating.subscribe(onNext: { _ in
            let pageSide = self.pageSize.width
            let offset = self.collectionView.contentOffset.x
            let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            self.setMovieDetails(currentPage: currentPage)
        }, onCompleted: {
            
        }).disposed(by: disposeBag)
        
    }
    
    private func bindLoading() {
        
        self.movieViewModel.movieObjects.asObservable().subscribe({
            _ in
            
            if(!(self.movieViewModel.movieObjects.value.isEmpty)) {
                
                DispatchQueue.main.async {
                    self.collectionView.isHidden = false
                    self.viewMovieDetail.isHidden = false
                    self.activity.isHidden = true
                    self.setMovieDetails(currentPage: 0)
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
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        self.setMovieDetails(currentPage: currentPage)
    }
    
}
