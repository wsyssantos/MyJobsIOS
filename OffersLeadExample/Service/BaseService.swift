//
//  BaseService.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import Foundation
import Alamofire

class BaseService {
    
    func getListUrls(_ callback:@escaping (NSDictionary) -> (Void), errorCallback:@escaping (NSError) -> (Void)) {
        var plistData: NSDictionary?
        if let path = Bundle.main.path(forResource: "ServicesConfig", ofType: "plist") {
            plistData = NSDictionary(contentsOfFile: path)
            let endpoint = plistData!["Service Endpoint"] as! String
            
            Alamofire
                .request(endpoint)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if let dictResponse = response.result.value as! NSDictionary?  {
                            callback(dictResponse)
                        }
                    case .failure(let error):
                        errorCallback(error as NSError)
                    }
                }
        }
    }
    
    func getCustomURL(_ url:String, callback:@escaping (NSDictionary) -> (Void), errorCallback:@escaping (NSError) -> (Void)) {
        Alamofire
            .request(url)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let dictResponse = response.result.value as! NSDictionary?  {
                        callback(dictResponse)
                    }
                case .failure(let error):
                    errorCallback(error as NSError)
                }
        }
    }
}
