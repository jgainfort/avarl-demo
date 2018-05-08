//
//  http-request.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import AVFoundation

func createURLRequest(url: URL, loadingRequest: AVAssetResourceLoadingRequest?) -> URLRequest {
    var request = URLRequest(url: url)

    if let dataRequest = loadingRequest?.dataRequest, !dataRequest.requestsAllDataToEndOfResource {
        let lower = dataRequest.requestedOffset
        let upper = lower + Int64(dataRequest.requestedLength) - 1
        let rangeHeader = "bytes=\(lower)-\(upper)"
        request.setValue(rangeHeader, forHTTPHeaderField: "Range")
    }

    return request
}
