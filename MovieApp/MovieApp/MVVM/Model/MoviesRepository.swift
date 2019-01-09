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

    private let dateFormatter = DateFormatter()
    
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
        
        let movieListURL = APIConstants.APIBaseURL + EndPoints.loadMore + "keyword=" + "\(dictParams!["keyword"] ?? "" as AnyObject)" + "&type=" + "\(dictParams!["type"] ?? "" as AnyObject)" + "&offset=" + "\(dictParams?["offset"] ?? "" as AnyObject)"
        
        super.GETDataRequset(taskCancel: false, requestUrl: movieListURL, parameter: nil, success: { (responseObject) in
            var movieList = JSON(responseObject!).dictionaryValue
            let arrTempList = movieList["results"]!.arrayValue
            success(self.setTheProperties(arrTempList: arrTempList))
        }) { (error) in
            failed(error)
        }
    }
    
    private func setTheProperties(arrTempList:[JSON]) -> Array<MovieObject> {
        
        var arrList = [MovieObject]()
        
        for tempDict in arrTempList {
            
            let movieObject = MovieObject()
            movieObject.strReleaseDate = getDate(timeStemp: (tempDict["release_date"].doubleValue))
            movieObject.strType = getMovieTypes(arrTypes: tempDict["genre_ids"].arrayValue)
            movieObject.isPreSeal =  (tempDict["presale_flag"].boolValue)
            movieObject.strAge =  (tempDict["age_category"].stringValue)
            movieObject.strDesc =  (tempDict["description"].stringValue)
            movieObject.urlImagePath =  (tempDict["poster_path"].url)
            movieObject.strTitle =  (tempDict["title"].stringValue)
            movieObject.rating =  (tempDict["rate"].doubleValue)
            arrList.append(movieObject)
        }
        
        return arrList
    }
    
    private func getDate(timeStemp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStemp)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func getMovieTypes(arrTypes: [JSON]) -> String {
        
        var strTypes = ""
        
        for tempType in arrTypes {
            
            if(strTypes == "") {
                strTypes = tempType["name"].stringValue
            }
            else {
                strTypes = strTypes + ", " + tempType["name"].stringValue
            }
        }
        
        return strTypes
    }
    
}
