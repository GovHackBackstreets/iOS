//
//  PostAPI.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 15/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.


import Foundation

class PostApi {
    
    func post(parameters: [String: Any], id: String) {
        let urlToRequest = "https://govhacksapi.herokuapp.com/scan/1"
        
        let url = URL(string: urlToRequest)!
    
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        request.httpBody = jsonData
        print(jsonData!)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print(request)
            
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                
                print("*****error")
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("*****This is the data 4: \(String(describing: dataString))")
            
        }
        
        task.resume()

        
//        let session = URLSession.shared
//        let url = "https://govhacksapi.herokuapp.com/scan/\(id)"
//        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
//        request.httpMethod = "PUT"
//        
//        do{
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
//            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
//                if let response = response {
//                    let nsHTTPResponse = response as! HTTPURLResponse
//                    let statusCode = nsHTTPResponse.statusCode
//                    print ("status code = \(statusCode)")
//                }
//                if let error = error {
//                    print ("\(error)")
//                }
//                guard let _: Data = data, let _: URLResponse = response, error == nil else {
//
//                    print("*****error")
//                    return
//                }
//                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("*****This is the data 4: \(String(describing: dataString))")
//            })
//            task.resume()
//        }catch _ {
//            print ("Oops something happened buddy")
//        }

    }
}


































