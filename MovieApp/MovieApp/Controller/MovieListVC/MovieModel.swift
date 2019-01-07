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
    var strTitle: String?
    var isPreSeal: Bool?
    var strType: String?
    var urlImagePath: URL?
    
    func getAllMoviesFromServer(dictParams:[String: AnyObject]?, success: @escaping (AnyObject?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIURL.movieList
        
        NetworkManager.BaseRequestSharedInstance.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: dictParams, success: { (responseObject) in
            success(self.setTheProperties(theDict: responseObject as! [String : AnyObject]) as AnyObject)
        }) { (error) in
            failed(error)
        }
    }
    
    func setTheProperties(theDict: [String: AnyObject]) -> Array<MovieModel> {
        
        var movieList = JSON(theDict).dictionaryValue
        let arrTempList = movieList["results"]!.arrayValue
        var arrList = [MovieModel]()
        
        for i in 0 ..< arrTempList.count {
            
            let tempDict = arrTempList[i]
            let movieModel = MovieModel()
            
            movieModel.strTitle =  (tempDict["title"].stringValue)
            movieModel.isPreSeal =  (tempDict["presale_flag"].boolValue)
            movieModel.urlImagePath =  (tempDict["poster_path"].url)
            
            let arrTypes = tempDict["genre_ids"].arrayValue
            for j in 0 ..< arrTypes.count {
                let tempType = arrTypes[j]
                
                if(movieModel.strType == nil) {
                    movieModel.strType = tempType["name"].stringValue
                }
                else {
                    movieModel.strType = movieModel.strType! + ", " + tempType["name"].stringValue
                }
            }
            
            arrList.append(movieModel)
        }
        
        return arrList
    }
    
}
