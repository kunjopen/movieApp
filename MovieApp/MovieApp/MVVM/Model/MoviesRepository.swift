//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by Ketan on 1/9/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import SwiftyJSON

class MoviesRepository: NetworkManager {

    func getAllMoviesFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieObject]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIBaseURL + EndPoints.movieList
        
        super.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: dictParams, success: { (responseObject) in
            var movieList = JSON(responseObject!).dictionaryValue
            let arrTempList = movieList["results"]!.arrayValue
            success(self.setTheProperties(arrTempList: arrTempList))
        }) { (error) in
            failed(error)
        }
    }
    
    func getSearchResultFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieObject]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIBaseURL + EndPoints.searchResult + "keyword=" + "\(dictParams!["keyword"] ?? "" as AnyObject)" + "&offset=" + "\(dictParams?["offset"] ?? "" as AnyObject)"
        
        super.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: nil, success: { (responseObject) in
            
            var movieList = JSON(responseObject!).dictionaryValue
            let dictResult = movieList["results"]?.dictionaryValue
            
            if((dictParams!["type"]?.string) == "comingsoon") {
                let arrUpcoming = dictResult?["upcoming"]?.arrayValue
                success(self.setTheProperties(arrTempList: arrUpcoming!))
            }
            else {
                let arrShowing = dictResult?["showing"]?.arrayValue
                success(self.setTheProperties(arrTempList: arrShowing!))
            }
            
        }) { (error) in
            failed(error)
        }
    }
    
    func loadMoreSearchResultFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieObject]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIBaseURL + EndPoints.searchResult + "keyword=" + "\(dictParams!["keyword"] ?? "" as AnyObject)" + "&type=" + "\(dictParams!["type"] ?? "" as AnyObject)" + "&offset=" + "\(dictParams?["offset"] ?? "" as AnyObject)"
        
        super.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: nil, success: { (responseObject) in
            var movieList = JSON(responseObject!).dictionaryValue
            let arrTempList = movieList["results"]!.arrayValue
            success(self.setTheProperties(arrTempList: arrTempList))
        }) { (error) in
            failed(error)
        }
        
    }
    
    func setTheProperties(arrTempList:[JSON]) -> Array<MovieObject> {
        
        var arrList = [MovieObject]()
        
        for i in 0 ..< arrTempList.count {
            
            let tempDict = arrTempList[i]
            let movieObject = MovieObject()
            
            movieObject.strTitle =  (tempDict["title"].stringValue)
            movieObject.isPreSeal =  (tempDict["presale_flag"].boolValue)
            movieObject.urlImagePath =  (tempDict["poster_path"].url)
            movieObject.strAge =  (tempDict["age_category"].stringValue)
            movieObject.rating =  (tempDict["rate"].doubleValue)
            movieObject.strDesc =  (tempDict["description"].stringValue)
            
            let date = Date(timeIntervalSince1970: (tempDict["release_date"].doubleValue))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let strDate = dateFormatter.string(from: date)
            movieObject.strReleaseDate = strDate
            
            
            let arrTypes = tempDict["genre_ids"].arrayValue
            
            for j in 0 ..< arrTypes.count {
                let tempType = arrTypes[j]
                
                if(movieObject.strType == nil) {
                    movieObject.strType = tempType["name"].stringValue
                }
                else {
                    movieObject.strType = movieObject.strType! + ", " + tempType["name"].stringValue
                }
            }
            
            arrList.append(movieObject)
        }
        
        return arrList
    }
    
}