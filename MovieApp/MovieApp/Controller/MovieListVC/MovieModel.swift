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
    var strAge: String?
    var rating: Double?
    var strReleaseDate: String?
    var strDesc: String?
    
    func getAllMoviesFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieModel]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIURL.movieList
        
        NetworkManager.BaseRequestSharedInstance.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: dictParams, success: { (responseObject) in
            var movieList = JSON(responseObject!).dictionaryValue
            let arrTempList = movieList["results"]!.arrayValue
            success(self.setTheProperties(arrTempList: arrTempList))
        }) { (error) in
            failed(error)
        }
    }
    
    func getSearchResultFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieModel]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIURL.searchResult + "keyword=" + "\(dictParams!["keyword"] ?? "" as AnyObject)" + "&offset=" + "\(dictParams?["offset"] ?? "" as AnyObject)"
        
        NetworkManager.BaseRequestSharedInstance.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: nil, success: { (responseObject) in
            
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
    
    func loadMoreSearchResultFromServer(dictParams:[String: AnyObject]?, success: @escaping ([MovieModel]?) -> Void,  failed: @escaping (AnyObject?) -> Void) {
        
        let movieListURL = APIConstants.APIURL.loadMore + "keyword=" + "\(dictParams!["keyword"] ?? "" as AnyObject)" + "&type=" + "\(dictParams!["type"] ?? "" as AnyObject)" + "&offset=" + "\(dictParams?["offset"] ?? "" as AnyObject)"
        
        NetworkManager.BaseRequestSharedInstance.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: nil, success: { (responseObject) in
            var movieList = JSON(responseObject!).dictionaryValue
            let arrTempList = movieList["results"]!.arrayValue
            success(self.setTheProperties(arrTempList: arrTempList))
        }) { (error) in
            failed(error)
        }
        
    }
    
    func setTheProperties(arrTempList:[JSON]) -> Array<MovieModel> {
        
        var arrList = [MovieModel]()
        
        for i in 0 ..< arrTempList.count {
            
            let tempDict = arrTempList[i]
            let movieModel = MovieModel()
            
            movieModel.strTitle =  (tempDict["title"].stringValue)
            movieModel.isPreSeal =  (tempDict["presale_flag"].boolValue)
            movieModel.urlImagePath =  (tempDict["poster_path"].url)
            movieModel.strAge =  (tempDict["age_category"].stringValue)
            movieModel.rating =  (tempDict["rate"].doubleValue)
            movieModel.strDesc =  (tempDict["description"].stringValue)
            
            let date = Date(timeIntervalSince1970: (tempDict["release_date"].doubleValue))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let strDate = dateFormatter.string(from: date)
            movieModel.strReleaseDate = strDate
            
            
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
