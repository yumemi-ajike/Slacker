//
//  URL+Extension.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import Foundation

extension URL {
    func hasPrefix(_ prefix: URL) -> Bool {
        return absoluteString.hasPrefix(prefix.absoluteString)
    }

    func queryItem(for key: String) -> Any? {
        var info: [String: Any] = [:]
        var components = URLComponents(url: self, resolvingAgainstBaseURL: baseURL != nil)
        components?.queryItems?.forEach({ (queryItem) in
            info[queryItem.name] = queryItem.value
        })
        return info[key]
    }
}
