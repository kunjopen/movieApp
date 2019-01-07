//
//  APIConstants.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

struct APIConstants {
    
    static let APIBaseURL = "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/"
    
    struct APIURL {
        static let movieList                = "\(APIBaseURL)home"
        static let searchResult             = "\(APIBaseURL)search?"
        static let loadMore                 = "\(APIBaseURL)loadmore?"
    }
    
}
