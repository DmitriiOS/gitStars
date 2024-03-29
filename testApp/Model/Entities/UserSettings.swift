//
//  UserSettings.swift
//  testApp
//
//  Created by Dmitriy Orlov on 11.11.2020.
//

import Foundation

final class UserSettings {
    
    private enum KeysForDefaults: String {
        case currentLogin
        case currentRepositoryIndex
        case startDate
        case endDate
    }
    
    static var currentLogin: String? {
        get {
            return UserDefaults.standard.string(forKey: KeysForDefaults.currentLogin.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = KeysForDefaults.currentLogin.rawValue
            if let login = newValue {
                defaults.set(login, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var currentRepositoryIndex: Int? {
        get {
            return UserDefaults.standard.object(forKey: KeysForDefaults.currentRepositoryIndex.rawValue) as? Int
        } set {
            let defaults = UserDefaults.standard
            let key = KeysForDefaults.currentRepositoryIndex.rawValue
            if let indexPath = newValue {
                defaults.set(indexPath, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}
