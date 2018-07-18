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
}
