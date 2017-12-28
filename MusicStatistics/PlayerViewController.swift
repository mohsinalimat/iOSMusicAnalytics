//
//  ViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {
    @IBOutlet weak var albumArt: UIImageView!
    var nowPlaying: MPMediaItem!
    
    func updateUI(with image:MPMediaItem){
        let artworkSize:CGSize = CGSize(width: 667, height: 667)
        let artwork = image.artwork!
        albumArt.image = artwork.image(at: artworkSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI(with: nowPlaying)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let dest = destinationViewController as? InfoTableViewController{
            dest.navigationItem.title = nowPlaying.title
            dest.info = nowPlaying
        }
    }


}

