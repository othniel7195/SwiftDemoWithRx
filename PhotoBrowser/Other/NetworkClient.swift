//
//  NetworkClient.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/8.
//  Copyright © 2019 zf. All rights reserved.
//

import UIKit
import Alamofire


enum RequestMethod {
    case GET
    case POST
}

class NetworkClient: NSObject {

    static let client: NetworkClient = NetworkClient()
    
    func request(method: RequestMethod , url: String, params: [String: Any], complete: @escaping ([[String:Any]])->Void){
        
        var rq: DataRequest?
        switch method {
        case .GET:
            rq = AF.request(url, method: .get, parameters: params)
        case .POST:
            rq = AF.request(url, method: .post, parameters: params)
        }
       
        rq?.responseJSON(completionHandler: { (DataResponse) in
            dPrint(item: DataResponse.value ?? "")
            if let jsonStr = (DataResponse.result.value as? [String: AnyObject]) {
                
                if let data = (jsonStr["data"] as? [[String: Any]]) {
                    complete(data)
                }
            }
            
        })
        
    }
}
