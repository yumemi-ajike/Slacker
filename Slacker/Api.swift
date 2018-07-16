//
//  Api.swift
//  Slacker
//
//  Created by Atsushi Jike on 2018/07/14.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Moya

enum Slack {
    case chatPostMessage(token: String, channel: String, text: String, asUser: Bool)
}

extension Slack: TargetType {
    var baseURL: URL { return URL(string: "https://slack.com/api")! }
    var path: String {
        switch self {
        case .chatPostMessage:
            return "/chat.postMessage"
        }
    }
    var method: Method {
        switch self {
        case .chatPostMessage:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .chatPostMessage(let token, let channel, let text, let asUser):
            return .requestParameters(parameters: ["token": token, "channel": channel, "text": text, "as_user": asUser], encoding: URLEncoding.default)
        }
    }
    var headers: [String : String]? { return nil }
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "chatPostMessage", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}

struct PostMessageResponse: Codable {
    let ok: Bool
    let channel: String
    let ts: String
    let message: Message
}

struct Message: Codable {
    let type: String
    let user: String
    let text: String
    let bot_id: String
    let ts: String
}
