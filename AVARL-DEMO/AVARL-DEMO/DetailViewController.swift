//
//  DetailViewController.swift
//  AVARL-DEMO
//
//  Created by John Gainfort Jr on 5/8/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var avarldelegate: AVARLDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlayerViewController, let delegate = avarldelegate {
            vc.avarldelegate = delegate
        }
    }

}
