//
//  ManifestParser.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

class ManifestParser {

    func parseManifest(data: Data, url: URL) -> Data {
        guard let manifest = String(data: data, encoding: .utf8) else { return data }

        let source = manifest.range(of: "#EXT-X-STREAM-INF") != nil ? parseMasterManifest(manifest, data: data, url: url) : parsePlaylist(manifest, data: data, url: url)

        return source.data(using: .utf8) ?? data
    }

    private func parseMasterManifest(_ manifest: String, data: Data, url: URL) -> String {
        let cgs = manifest.capturedGroups(withRegex: "((?:#.+[\\s]*)+)[\\s]+(.+\\.m3u8.*)[\\s]?")

        return cgs.reduce("", { (acc, cur) -> String in
            let absUrl = url.absoluteString(from: cur[1], customScheme: "remedia")
            return acc + "\(cur[0])\n\(absUrl)\n"
        })
    }

    private func parsePlaylist(_ manifest: String, data: Data, url: URL) -> String {
        let cgs = manifest.capturedGroups(withRegex: "((?:#.+[\\s]*)+)[\\s]?+(.+\\.ts.*)?[\\s]?")

        return cgs.reduce("", { (acc, cur) -> String in
            var result = acc
            if cur.count > 1 {
                let absUrl = url.absoluteString(from: cur[1], customScheme: "")
                result += "\(cur[0])\n\(absUrl)\n"
            } else {
                result += "\(cur[0])"
            }
            return result
        })
    }
    
}
