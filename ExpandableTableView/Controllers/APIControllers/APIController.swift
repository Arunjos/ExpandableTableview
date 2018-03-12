//
//  APIController.swift
//  ExpandableTableView
//
//  Created by user on 12/03/18.
//  Copyright © 2018 Arun's Technologies. All rights reserved.
//

import Foundation
import Alamofire

public typealias APICompletionClosure = (Error?, Any?) -> ()

protocol APIController{
    func performRequest(completionHandler:@escaping APICompletionClosure)
}

class GetAPIController:APIController {
    
    var url:String = ""
    var parameters:[String:Any]?
    init(url:String, parameters:[String:Any]?) {
        self.url = url
        self.parameters = parameters ?? ["":""]
    }
    
    func performRequest(completionHandler:@escaping APICompletionClosure) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        Alamofire.request(url, method:.get,parameters:parameters, headers: headers).responseJSON { response in
            let errorCode:Int = (response.response?.statusCode) ?? 10000
            if (errorCode >= 400) {
                completionHandler(response.error, nil)
            } else {
                completionHandler(nil, response.result.value)
            }
        }
    }
    
}


