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

struct ChannelsListResponse: Codable {
    let ok: Bool
    let channels: [Channel]
}

struct GroupsListResponse: Codable {
    let ok: Bool
    let groups: [Group]
}

struct Channel: Codable {
    let id: String
    let name: String
    let isChannel: Bool
    let created: Int
    let creator: String
    let isArchived: Bool
    let isGeneral: Bool
    let nameNormalized: String
    let isShared: Bool
    let isOrgShared: Bool
    let isMember: Bool
    let isPrivate: Bool
    let isMpim: Bool
    let members: [String]
    let topic: Topic
    let purpose: Topic
    let previousNames: [String]
    let numMembers: Int
}

struct Group: Codable {
    let id: String
    let name: String
    let created: Int
    let creator: String
    let isArchived: Bool
    let isMpim: Bool
    let members: [String]
    let topic: Topic
    let purpose: Topic
}

struct Topic: Codable {
    let value: String
    let creator: String
    let lastSet: Int
}
