//
//  CurrentLogin.swift
//  testApp
//
//  Created by Dmitriy Orlov on 11.11.2020.
//

import Foundation

final class UserSettings {
    
    private enum KeysForDefaults: String {
        case currentLogin
        case cellIndexPath
        case startDate
        case endDate
    }
    
    static var currentLogin: String! {
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
    
    static var cellIndexPath: Int! {
        get {
            return UserDefaults.standard.integer(forKey: KeysForDefaults.cellIndexPath.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = KeysForDefaults.cellIndexPath.rawValue
            if let indexPath = newValue {
                defaults.set(indexPath, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
//    static var startDate: Date! {
//        get {
//            return UserDefaults.standard.object(forKey: KeysForDefaults.startDate.rawValue) as? Date
//        } set {
//            let defaults = UserDefaults.standard
//            let key = KeysForDefaults.startDate.rawValue
//            if let start = newValue {
//                defaults.set(start, forKey: key)
//            } else {
//                defaults.removeObject(forKey: key)
//            }
//        }
//    }
//    
//    static var endDate: Date! {
//        get {
//            return UserDefaults.standard.object(forKey: KeysForDefaults.endDate.rawValue) as? Date
//        } set {
//            let defaults = UserDefaults.standard
//            let key = KeysForDefaults.endDate.rawValue
//            if let end = newValue {
//                defaults.set(end, forKey: key)
//            } else {
//                defaults.removeObject(forKey: key)
//            }
//        }
//    }
    
}
