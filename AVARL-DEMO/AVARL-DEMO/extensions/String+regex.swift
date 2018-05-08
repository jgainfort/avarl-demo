//
//  String+regex.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

extension String {

    func capturedGroups(withRegex pattern: String) -> [[String]] {
        var results = [[String]]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }

        let text = self as NSString
        let count = text.length
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count))

        for match in matches {
            var group = [String]()
            for n in 1 ..< match.numberOfRanges {
                let range = match.range(at: n)
                if range.location <= count {
                    let str = (self as NSString).substring(with: range)
                    group.append(str)
                }
            }
            results.append(group)
        }

        return results
    }

}
