//
//  PlayerView.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    func initPlayer(withLoaderDelegate delegate: AVARLDelegate?) {
        let urlStr = "http://sprtott22-i.akamaihd.net/hls/live/250900/emily-test0405073556/master_vod.m3u8"
        let token = "token=exp=1675719581~acl=/hls/live/*~hmac=af5befe22fb8b4d6731824316370d384546418b52d902591b53447d6b7dde685"

        guard let url = URL(string: "\(urlStr)?\(token)") else { fatalError("invalid url") }

        var asset = AVURLAsset(url: url)
        if let delegate = delegate {
            asset = AVURLAsset(url: url.append(withScheme: "remedia"))
            let loaderQueue = DispatchQueue(label: "com.realeyes.AVARL-DEMO.LoaderQueue")
            asset.resourceLoader.setDelegate(delegate, queue: loaderQueue)
        }

        let item = AVPlayerItem(asset: asset)

        player = AVPlayer(playerItem: item)
        player?.playImmediately(atRate: 1.0)
    }

}
