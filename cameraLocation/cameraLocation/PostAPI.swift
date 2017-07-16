//
//  PostAPI.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 15/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.


import Foundation

class FinishedTask {
    
    var basic: Bool = false
    init(basic: Bool) {
        self.basic = basic
    }
    
}

class PostApi {

    
    func post(parameters: [String: Any], id: String, closure: @escaping(FinishedTask) -> Void) {
        let urlToRequest = "https://govhacksapi.herokuapp.com/scan/1"
        let header = [
            "content-type": "application/json",
        ]
        
        print(parameters)
        
        let url = URL(string: urlToRequest)!
    
        let session4 = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.allHTTPHeaderFields = header
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        request.httpBody = jsonData
        print(jsonData!)
        
        let task = session4.dataTask(with: request) { (data, response, error) in
                    
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print(data!)
                print("*****error")
                print(response!)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("*****This is the data 4: \(String(describing: dataString))")
            
            let finished = true
            let callBack = FinishedTask(basic: finished)
            
            DispatchQueue.main.async {
                closure(callBack)
            }
            
            
        }
        
        task.resume()

    }
}


































