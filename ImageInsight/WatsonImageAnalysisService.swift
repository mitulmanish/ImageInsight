//
//  WatsonImageAnalysisService.swift
//  ImageInsight
//
//  Created by Mitul Manish on 20/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import Alamofire

class WatsonImageAnalysisService {
    
    static let sharedInstance = WatsonImageAnalysisService()
    let baseURL: String!
    
    private init() {
        self.baseURL = Constant.baseURL
    }
    
    func getDataFromService(imageURL: String, completionHandler: @escaping ([String: AnyObject]) -> ()) {
        
        let params: [String: String] = ["api_key": Constant.apiKey,
                                        "url": "\(imageURL)",
                                        "version": Constant.version]
        let headers = ["Content-type": "application/json", "Accept": "application/json"]
        
        Alamofire.request(baseURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            
            if let dataFromServer = response.result.value {
                if let dictionary = dataFromServer as? [String: AnyObject] {
                    completionHandler(dictionary)
                }
            }
        }
    }
}
