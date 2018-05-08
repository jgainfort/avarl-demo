//
//  PlayerViewController.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerView: PlayerView!

    var avarldelegate: AVARLDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.initPlayer(withLoaderDelegate: avarldelegate)
    }

}
