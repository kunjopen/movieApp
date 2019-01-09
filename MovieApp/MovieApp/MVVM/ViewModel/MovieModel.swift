//
//  MovieModel.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieModel {
    
    var dataItems:[MovieObject] = []
    var repository: MoviesRepository?
    
    init() {
        repository = MoviesRepository()
    }
    
    
    func getAllMoviesFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieObject]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        repository?.getAllMoviesFromServer(dictParams: dictParams, success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
    }
    
    func getSearchResultFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieObject]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        repository?.getSearchResultFromServer(dictParams: dictParams, success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
        
    }
    
    func loadMoreSearchResultFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieObject]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        repository?.loadMoreSearchResultFromServer(dictParams: dictParams, success: { (response) in
            success(response)
        }, failed: { (error) in
            failed(error)
        })
    }
    
}
