//
//  URLDefinitions.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Foundation

extension URL {
    struct authentication {
        static let beginUrl = URL(string: "https://slack.com/oauth/authorize?client_id=\(String.app.clientId)&scope=\(String.app.scope)")!
        static let redirectUrl = URL(string: "https://sevenblox.com/authentication/slacker")!
    }
}
