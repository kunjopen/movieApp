//
//  APIManager.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

let TIME_OUT_INTERVAL = 120

private func getHeaderData() -> Dictionary<String, String> {
    
    var params = [String:String]()
    params["Content-Type"] = "application/json"
    params["Accept"] = "application/json"
    return params
}

class NetworkManager: NSObject {
    
    var taskPost: URLSessionTask? = nil
    
    func GETDataRequset(taskCancel:Bool ,requestUrl:String, parameter:[String : AnyObject]?, success:@escaping (AnyObject?) -> Void, failed:@escaping (AnyObject?) -> Void) {
        self.startProgressLoading()
        
        var jsonData : Data?
        
        if parameter != nil{
            jsonData = try? JSONSerialization.data(
                withJSONObject: parameter as Any, options: .prettyPrinted
            )
        }
        
        let url = URL(string: requestUrl)
        let request = NSMutableURLRequest(url: url!)
        request.timeoutInterval = TimeInterval(TIME_OUT_INTERVAL)
        
        let headerData = getHeaderData()
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headerData
        
        request.httpBody = jsonData
        if taskCancel {
            taskPost!.cancel()
            taskPost = nil
        }
        
        taskPost = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            dataRecieved, response, error in
            
            print("##############################################################################")
            print("URL: \(String(describing: url))")
            print("PARAMS: \(String(describing: parameter))")
            print("METHOD: Post")
            print("HEADER: \(String(describing: headerData))")
            
            guard let _ = dataRecieved, error == nil else {
                print("O/P error=\(error.debugDescription)")
                
                failed(error?.localizedDescription as AnyObject)
                self.stopProgressLoading()
                
                return
            }
            
            
            self.handleResponse(data:dataRecieved, response:response, error:error , success: { (response) in
                print("##############################################################################")
                if let dict = self.convertToDictionary(text: response as! String) {
                    success(dict as AnyObject)
                }
                
            }, failed: { (errorDescription) in
                
                if(errorDescription.debugDescription == "The network connection was lost.") {
                    self.GETDataRequset(taskCancel: taskCancel, requestUrl: requestUrl, parameter: parameter, success: success, failed: failed)
                }
                else {
                    failed(errorDescription)
                }
            })
        })
        
        taskPost?.resume()
        
    }
    
    private func startProgressLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private func stopProgressLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func handleResponse(data:Data? , response:URLResponse?, error:Error?, success:@escaping (AnyObject) -> Void, failed:@escaping (AnyObject?) -> Void) {
        
        let httpStatus = response as? HTTPURLResponse
        let statusCode = httpStatus?.statusCode
        
        self.stopProgressLoading()
        
        let responseString = String(data: data! , encoding: .utf8)
        
        if let dict = self.convertToDictionary(text: responseString!) {
            print("O/P Dict = \(dict)")
            
        } else {
            print("O/P responseString = \(String(describing: responseString))")
            
        }
        
        switch statusCode! as NSNumber {
        case 200:
            success(responseString as AnyObject)
            
        default:
            failed(responseString as AnyObject)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
                print("error in web service \(text)")
            }
        }
        return nil
    }
    
    func forceLogout() {
    }
}
