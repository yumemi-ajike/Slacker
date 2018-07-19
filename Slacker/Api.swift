//
//  Api.swift
//  Slacker
//
//  Created by Atsushi Jike on 2018/07/14.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Moya

class Api {
    static let shared = Api()

    func send<Request: SlackApiTargetType>(_ request: Request, completion: @escaping (_ response: Request.Response?, _ error: Moya.MoyaError?) -> Void) -> Void {
        let provider = MoyaProvider<MultiTarget>()
        let target = MultiTarget(request)
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedResponse = try response.map(Request.Response.self, using: jsonDecoder, failsOnEmptyData: true)
                    completion(decodedResponse, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}

protocol SlackApiTargetType: TargetType {
    associatedtype Response: Codable
}

extension SlackApiTargetType {
    var baseURL: URL { return URL(string: "https://slack.com/api")! }
    var headers: [String : String]? { return nil }
}

enum Slack {
    struct ChatPostMessage: SlackApiTargetType {
        typealias Response = MessageResponse
        var path: String { return "/chat.postMessage" }
        var method: Method { return .post }
        var task: Task {
            return .requestParameters(parameters: ["token": token, "channel": channel, "text": text, "as_user": asUser], encoding: URLEncoding.default)
        }
        var sampleData: Data {
            let path = Bundle.main.path(forResource: "chatPostMessage", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }
        let token: String
        let channel: String
        let text: String
        let asUser: Bool
        
        init(token: String, channel: String, text: String, asUser: Bool) {
            self.token = token
            self.channel = channel
            self.text = text
            self.asUser = asUser
        }
    }

    struct OAuthAccess: SlackApiTargetType {
        typealias Response = OAuthAccessResponse
        var path: String { return "/oauth.access" }
        var method: Method { return .post }
        var task: Task {
            return .requestParameters(parameters: ["client_id": clientId, "client_secret": clientSecret, "code": code], encoding: URLEncoding.default)
        }
        var sampleData: Data {
            let path = Bundle.main.path(forResource: "oAuthAccess", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }
        let clientId: String
        let clientSecret: String
        let code: String

        init(clientId: String, clientSecret: String, code: String) {
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.code = code
        }
    }

    struct ChannelsList: SlackApiTargetType {
        typealias Response = ChannelsListResponse
        var path: String { return "/channels.list" }
        var method: Method { return .get }
        var task: Task {
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.default)
        }
        var sampleData: Data {
            let path = Bundle.main.path(forResource: "channelsList", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }
        let token: String

        init(token: String) {
            self.token = token
        }
    }

    struct GroupsList: SlackApiTargetType {
        typealias Response = GroupsListResponse
        var path: String { return "/groups.list" }
        var method: Method { return .get }
        var task: Task {
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.default)
        }
        var sampleData: Data {
            let path = Bundle.main.path(forResource: "groupsList", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }
        let token: String
        
        init(token: String) {
            self.token = token
        }
    }
}
