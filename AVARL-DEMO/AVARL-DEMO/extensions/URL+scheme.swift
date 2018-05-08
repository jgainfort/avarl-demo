//
//  URL+scheme.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

extension URL {

    func append(withScheme scheme: String) -> URL {
        let str = "\(scheme)\(self.absoluteString)"
        return URL(string: str) ?? self
    }

    func remove(scheme: String) -> URL {
        let str = self.absoluteString.replacingOccurrences(of: scheme, with: "")
        return URL(string: str) ?? self
    }

    func absoluteString(from relUrl: String, customScheme: String) -> String {
        // one place this is used is in a frag capture group for an endlist tag which does not have a url associated with it
        // this keeps all parsing logic for the "frag" working with minimal effort
        if relUrl == "" { return relUrl }

        var absUrl = "\(customScheme)"

        guard let scheme = self.scheme, let host = self.host else { return relUrl } // TODO: error
        let basePath = self.deletingQuery().deletingLastPathComponent().absoluteString
        var origin = "\(scheme)://\(host)"

        if let port = self.port {
            origin += ":\(port)"
        }

        let startIdx = relUrl.index(relUrl.startIndex, offsetBy: 0)

        if relUrl.range(of: "http") != nil {
            absUrl += "\(relUrl)"
        } else {
            absUrl += relUrl[startIdx] == "/" ? "\(origin)\(relUrl)" : "\(basePath)\(relUrl)"
        }

        return absUrl
    }

    func deletingQuery() -> URL {
        let str = self.absoluteString.split(separator: "?")[0]
        return URL(string: String(str))!
    }

}
