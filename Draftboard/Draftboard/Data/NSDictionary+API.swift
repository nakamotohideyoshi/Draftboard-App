//
//  NSDictionary+API.swift
//  Draftboard
//
//  Created by Anson Schall on 5/4/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

extension NSDictionary {
    // Retrieve value for key, unwrap, and cast as T; or throw
    func get<T>(key: Key) throws -> T {
        guard let value = self[key] else {
            throw APIError.JSONKeyNotFound(self, key)
        }
        guard let valueT = value as? T else {
            throw APIError.JSONTypeMismatch(value, T.self)
        }
        return valueT
    }
}