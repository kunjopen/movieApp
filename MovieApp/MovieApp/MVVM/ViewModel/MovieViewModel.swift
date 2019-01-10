//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift


class MovieViewModel {
    
    private var repository = MoviesRepository()
    var movieObjects: Variable<[MovieObject]> = Variable([])
    
    func getAllMoviesFromServer() {
        
        repository.getAllMoviesFromServer(success: { (response) in
            self.movieObjects.value = response!
        }, failed: { (error) in
            print(error ?? "")
        })
    }
    
    func getSearchResultFromServer(dictParams:[String: AnyObject]?) {
        
        repository.getSearchResultFromServer(dictParams: dictParams, success: { (response) in
            self.movieObjects.value = response!
        }, failed: { (error) in
            print(error ?? "")
        })
    }
    
    func loadMoreSearchResultFromServer(dictParams:[String: AnyObject]?) {
        
        repository.loadMoreSearchResultFromServer(dictParams: dictParams, success: { (response) in
            self.movieObjects.value = self.movieObjects.value + response!
        }, failed: { (error) in
            print(error ?? "")
        })
    }
}



