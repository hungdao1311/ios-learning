//
//  Settings.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/14/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

class Settings {
    var accessToken: String? {
        get {
            return getString("accessToken")
        }
        set(newValue) {
            putString("accessToken", newValue)
        }
    }
    
    private var data = [String: Any] ()
    
    private func putString(_ key: String, _ value: String?) {
        if (value == nil) {
            data.removeValue(forKey: key)
        } else {
            data[key] = value
        }
    }
    
    private func getString(_ key : String) -> String? {
        return data[key] as! String?
    }
    
    private static var instance : Settings?
    
    static var shared : Settings {
        if (instance == nil) {
            instance = Settings()
        }
        return instance!
    }
}
