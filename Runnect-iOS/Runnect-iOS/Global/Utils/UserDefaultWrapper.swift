//
//  UserDefaultWrapper.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import Foundation

@propertyWrapper struct UserDefaultWrapper<T> {
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: self.key) as? T
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else { UserDefaults.standard.setValue(newValue, forKey: key) }
        }
    }
    
    private let key: String
    
    init(key: String) {
        self.key = key
    }
}
