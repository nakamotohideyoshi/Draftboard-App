//
//  API+Errors.swift
//  Draftboard
//
//  Created by Anson Schall on 5/4/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation
import PromiseKit

enum APIError: ErrorType {
    case InvalidJSON(String?, ErrorType)
    case JSONKeyNotFound(Any, Any)
    case JSONTypeMismatch(Any, Any.Type)
    case InvalidToken(APIRequest)
    case InvalidDateString(String)
    case ModelError(Any.Type, ErrorType)
    case Whatever
}

typealias APIRequestErrorCondition = (APIRequest, NSData, String, NSHTTPURLResponse) -> ErrorType?

private typealias API_Errors = API
extension API_Errors {
    
    static let InvalidTokenCondition: APIRequestErrorCondition = { request, _, string, response in
        if response.statusCode == 403 && string.lowercaseString.containsString("signature") {
            return APIError.InvalidToken(request)
        }
        if response.statusCode == 403 && string.lowercaseString.containsString("credentials") {
            return APIError.InvalidToken(request)
        }
        return nil
    }
    
}
