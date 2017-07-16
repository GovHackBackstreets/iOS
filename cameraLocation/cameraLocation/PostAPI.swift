//
//  PostAPI.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 15/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.


import Foundation

class PostApi {
    
    func post(parameters: [String: Any], id: String) {
        let urlToRequest = "https://requestb.in/tu1tyitu"
        
        print(parameters)
        
        let url = URL(string: urlToRequest)!
    
        let session4 = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
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
            
        }
        
        task.resume()

    }
}


































