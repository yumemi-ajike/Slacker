//
//  UserDefaultsDefinitions.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var accessToken: String {
        get {
            return UserDefaults.standard.object(forKey: "accessToken") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }

    static var channelIds: [String] {
        get {
            return UserDefaults.standard.object(forKey: "channelIds") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "channelIds")
        }
    }
}
