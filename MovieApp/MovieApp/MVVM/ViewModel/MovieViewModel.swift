//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ViewModelMovieDelegate: class {
    func reloadData()
}


class MovieViewModel {
    
    private var repository = MoviesRepository()
    weak var delegate: ViewModelMovieDelegate?
    var movieObjects = [MovieObject]()
    
    
    func getAllMoviesFromServer(dictParams:[String: AnyObject]?) {
        
        repository.getAllMoviesFromServer(dictParams: dictParams, success: { (response) in
            self.movieObjects = response!
            self.delegate?.reloadData()
        }, failed: { (error) in
            print(error ?? "")
        })
    }
    
    func getSearchResultFromServer(dictParams:[String: AnyObject]?) {
        
        repository.getSearchResultFromServer(dictParams: dictParams, success: { (response) in
            self.movieObjects = response!
            self.delegate?.reloadData()
        }, failed: { (error) in
            print(error ?? "")
        })
    }
    
    func loadMoreSearchResultFromServer(dictParams:[String: AnyObject]?) {
        
        repository.loadMoreSearchResultFromServer(dictParams: dictParams, success: { (response) in
            self.movieObjects = self.movieObjects + response!
            self.delegate?.reloadData()
        }, failed: { (error) in
            print(error ?? "")
        })
    }
}
