//
//  Response.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/18.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Foundation

struct MessageResponse: Codable {
    let ok: Bool
    let channel: String
    let ts: String
    let message: Message
}

struct Message: Codable {
    let type: String
    let user: String
    let text: String
    let botId: String
    let ts: String
}

struct OAuthAccessResponse: Codable {
    let accessToken: String
    let scope: String
    let teamName: String
    let teamId: String
}
