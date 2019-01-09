//
//  APIConstants.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

struct APIConstants {
    
    static let apiVersion           : String = "/mock"
    static let domainAPI            : String = "/5c19c6ff64b4573fc81a61f3/movieapp/"
    static let protocolo            : String = "https://"
    static let domain               : String = "easy-mock.com"
    
    static let APIBaseURL           : String = APIConstants.protocolo + APIConstants.domain + APIConstants.apiVersion + APIConstants.domainAPI
}
