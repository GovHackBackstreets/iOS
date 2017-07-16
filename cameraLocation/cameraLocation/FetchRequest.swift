//
//  FetchRequest.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 16/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import Foundation

class FetchMe {
    
    let latitude: Double
    let longitude: Double
    let locationName: String
    let chemicalCount: Double
    let microSafety: Double
    let physicalQuality: Double
    let tempControl: Double
    
    init(json: [String: Any]) {
        
        if let geloc = json["geoloc"] as? [String:Any] {
            self.latitude = geloc["lat"] as! Double
            self.longitude = geloc["long"] as! Double
        } else {
            self.latitude = 0
            self.longitude = 0
        }
        self.locationName = json["locationName"] as! String
        self.chemicalCount = json["chemicalContaminents"] as! Double
        self.physicalQuality = json["physicalQuality"] as! Double
        self.tempControl = json["temperatureControl"] as! Double
        self.microSafety = json["microbialSafety"] as! Double
        
        
    }
    
}

class LoadingData {
    
    var refhandle: UInt = 0
    let articles: [[String: String]] = []
    let id = String()
    
    func theDispatchQueue(closure: @escaping ([FetchMe]) -> Void) {
        
        var foodArray: [FetchMe] = []
        
        var request = URLRequest(url: URL(string: "https://govhacksapi.herokuapp.com/scan/1")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            if let theData = data {
                print(theData)
                do{
                    let json = try JSONSerialization.jsonObject(with: theData, options:.allowFragments) as! [String : AnyObject]
                    
                    print(json["stamps"]!)
                    
                    let stamps = json["stamps"] as? [[String: Any]] ?? [[:]]
                    
                    for i in stamps {
    
                        print(i)
                        let remiData = FetchMe(json: i)
                        foodArray.append(remiData)

                    }
                    
                    DispatchQueue.main.async {
                        closure(foodArray)
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            
                

                }
            
            }.resume()
    
        
    }
    
}






























