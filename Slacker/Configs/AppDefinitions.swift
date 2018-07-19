//
//  AppDefinitions.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Foundation

extension String {
    struct app {
        static let clientId = "<APP_CLIENT_ID>"
        static let clientSecret = "<APP_CLIENT_SECRET>"
        static let scope = "channels:read,chat:write:user,groups:read"
    }
}
