//
//  APIRequest.swift
//  Draftboard
//
//  Created by Anson Schall on 5/3/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class APIRequest: NSMutableURLRequest {
    
    var errorConditions: [APIRequestErrorCondition] = []
    
    init(_ path: String, JSON: AnyObject? = nil) {
        let URL = NSURL(string: API.baseURL + path)!
        super.init(URL: URL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 60)
        
        // Settings for both GET and POST
        setValue(API.agent, forHTTPHeaderField: "User-Agent")
        setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Settings for POST, which is assumed when JSON != nil
        if let JSON = JSON {
            HTTPMethod = "POST"
            HTTPBody = try! NSJSONSerialization.dataWithJSONObject(JSON, options: [])
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

