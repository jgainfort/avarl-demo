//
//  AVARLDelegate.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import AVFoundation

enum AVARLError: Error {
    case invalidResponse
}

class AVARLDelegate: NSObject, AVAssetResourceLoaderDelegate {

    private let parser = ManifestParser()
    private var requests = [String: URLSessionDataTask]()

    deinit {
        requests.forEach { (_, value) in
            value.cancel()
        }
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url?.remove(scheme: "remedia") else { return false }

        if (url.pathExtension == "ts") {
            return false
        }

        makeRequest(withURL: url, loadingRequest: loadingRequest)

        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        guard let url =  loadingRequest.request.url?.remove(scheme: "remedia") else { return }

        guard let cancelRequest = requests[url.absoluteString] else { return }
        cancelRequest.cancel()
    }

    private func makeRequest(withURL url: URL, loadingRequest: AVAssetResourceLoadingRequest) {
        let request = createURLRequest(url: url, loadingRequest: loadingRequest)

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) { [weak self] (data, res, error) in
            guard error == nil else {
                loadingRequest.response = res
                loadingRequest.finishLoading(with: error)
                return
            }

            guard let data = data, let res = res else {
                let error = AVARLError.invalidResponse
                loadingRequest.finishLoading(with: error)
                return
            }

            if let infoRequest = loadingRequest.contentInformationRequest {
                self?.handleContentRequest(response: res, infoRequest: infoRequest)
            }

            if let dataRequest = loadingRequest.dataRequest {
                self?.handleDataRequest(response: res, data: data, url: url, dataRequest: dataRequest, loadingRequest: loadingRequest)
            } else {
                loadingRequest.response = res
                loadingRequest.finishLoading()
            }
        }

        task.resume()

        requests[url.absoluteString] = task
    }

    private func handleContentRequest(response: URLResponse, infoRequest: AVAssetResourceLoadingContentInformationRequest) {
        if let httpResponse = response as? HTTPURLResponse {
            let contentType = httpResponse.find(header: "Content-Type")

            if contentType == "text/plain" {
                infoRequest.contentType = AVStreamingKeyDeliveryPersistentContentKeyType
            } else {
                infoRequest.contentType = contentType ?? "application/x-mpegURL"
            }

            if let cl = httpResponse.find(header: "Content-Length"), let intCl = Int64(cl) {
                infoRequest.contentLength = intCl
            }

            if let contentRange = httpResponse.find(header: "Content-Range") {
                let capturedGroups = contentRange.capturedGroups(withRegex: "bytes (\\d+)-(\\d+)/(\\d+)")
                if capturedGroups.count > 0 {
                    let startIdx = Int64(capturedGroups[0][0]) ?? 0
                    let endIdx = Int64(capturedGroups[0][1]) ?? 0

                    if endIdx > 0 {
                        infoRequest.contentLength = endIdx > 0 ? endIdx - startIdx + 1 : 0
                    }
                }
                infoRequest.isByteRangeAccessSupported = true
            }
        }
    }

    private func handleDataRequest(response: URLResponse, data: Data, url: URL, dataRequest: AVAssetResourceLoadingDataRequest, loadingRequest: AVAssetResourceLoadingRequest) {
        if url.pathExtension == "m3u8" {
            let manifest = parser.parseManifest(data: data, url: url)
            dataRequest.respond(with: manifest)
            loadingRequest.response = response
            loadingRequest.finishLoading()
        } else {
            dataRequest.respond(with: data)
            loadingRequest.response = response
            loadingRequest.finishLoading()
        }
    }

}
