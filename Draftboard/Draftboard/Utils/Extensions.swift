//
//  Extensions.swift
//  Draftboard
//
//  Created by Anson Schall on 6/3/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

extension Array {
    
    // Like lodash's _.keyBy
    func keyBy<T>(@noescape getKey: Element -> T) -> [T: Element] {
        var result = [T: Element]()
        forEach { value in
            let key = getKey(value)
            result[key] = value
        }
        return result
    }
    
    // Like lodash's _.groupBy
    func groupBy<T>(@noescape getKey: Element -> T) -> [T: [Element]] {
        var result = [T: [Element]]()
        forEach { value in
            let key = getKey(value)
            if result[key] == nil {
                result[key] = [Element]()
            }
            result[key]!.append(value)
        }
        return result
    }
    
    // Like lodash's _.countBy
    func countBy<T>(@noescape getKey: Element -> T) -> [T: Int] {
        var result = [T: Int]()
        forEach { value in
            let key = getKey(value)
            result[key] = (result[key] ?? 0) + 1
        }
        return result
    }
    
    // Somewhat similar to lodash's _.transform and stdlib's reduce
    func transform<T>(initial: T, @noescape combine: (inout T, Element) -> T) -> T {
        var result = initial
        forEach { value in
            result = combine(&result, value)
        }
        return result
    }

    // Somewhat similar to lodash's _.sortBy and _.orderBy
    func sortBy<T: Comparable>(@noescape getKey: Element -> T) -> [Element] {
        return sort { getKey($0) < getKey($1) }
    }
    
    func sortBy<T: Comparable>(@noescape isOrderedBefore: (T, T) -> Bool, @noescape getKey: Element -> T) -> [Element] {
        return sort { isOrderedBefore(getKey($0), getKey($1)) }
    }
    
    // Like lodash's _.uniqBy
    func uniqBy<T:Hashable>(@noescape getKey: Element -> T) -> [Element] {
        var seen = [T: Bool]()
        return filter { value in
            seen.updateValue(true, forKey: getKey(value)) == nil
        }
    }

//    // Somewhat similar to lodash's _.sortBy and _.orderBy
//    func sortBy<T: Comparable>(@noescape getKey: Element throws -> T) rethrows -> [Element] {
//        return try sort { try getKey($0) < getKey($1) }
//    }
//
//    func sortBy<T: Comparable>(@noescape isOrderedBefore: (T, T) -> Bool, @noescape getKey: Element throws -> T) rethrows -> [Element] {
//        return try sort { try isOrderedBefore(getKey($0), getKey($1)) }
//    }
//    
//    // Throwing version of stdlib sort
//    func sort(@noescape isOrderedBefore: (Element, Element) throws -> Bool) rethrows -> [Element] {
//        return sort {
//            do {
//                try return isOrderedBefore($0, $1)
//            } catch let error {
//                throw error
//            }
//        }
////        do {
////        return try sort { try isOrderedBefore($0, $1) }
//    }

}

extension Array where Element: Hashable {
    
    // Like lodash's _.uniq
    func uniq() -> [Element] {
        return uniqBy { $0 }
    }
    
}

extension Dictionary {
    
    // Somewhat similar to lodash's _.assign, but not mutating
    func assign(dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = [Key: Value]()
        for dict in dictionaries {
            for (key, value) in dict {
                result[key] = value
            }
        }
        return result
    }
    
}


// Date comparison
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

// Optional arrays with Equatable Elements
func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs,rhs) {
    case (.Some(let lhs), .Some(let rhs)):
        return lhs == rhs
    case (.None, .None):
        return true
    default:
        return false
    }
}
func !=<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    return !(lhs == rhs)
}



