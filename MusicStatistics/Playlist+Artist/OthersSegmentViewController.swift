//
//  OthersSegmentViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 2/16/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class OthersSegmentViewController: UIViewController {

    @IBOutlet weak var playlistView: UIView!
    @IBOutlet weak var artistView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistView.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchOthersMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0://artist
            artistView.isHidden = false
            playlistView.isHidden = true
            self.title = "Artists"
        case 1: // artist
            artistView.isHidden = true
            playlistView.isHidden = false
            self.title = "Playlists"
        default: break
        }
    }
}
