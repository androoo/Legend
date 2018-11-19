//
//  DictionaryExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension Dictionary {
    public init(keyValuePairs: [(Key, Value)]) {
        self.init()
        for pair in keyValuePairs {
            self[pair.0] = pair.1
        }
    }
    
    mutating func unionInPlace(dictionary: Dictionary) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }
    
    func union(dictionary: Dictionary) -> Dictionary {
        var mutatingDictionary = dictionary
        mutatingDictionary.unionInPlace(dictionary: self)
        return mutatingDictionary
    }
}
