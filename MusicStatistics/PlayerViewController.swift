//
//  ViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var albumArt: UIImageView?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    var nowPlaying: MPMediaItem!
    var player:MPMusicPlayerApplicationController!
    var playOrPause: Bool!
    var collection:MPMediaItemCollection!
    
    
    func updateUI(with song:MPMediaItem){
        let frame = UIScreen.main.bounds.size
        let artworkSize:CGSize = CGSize(width: frame.width, height: frame.width)
        let artwork = song.artwork
        albumArt?.image = artwork?.image(at: artworkSize)
        songTitle.text = song.title
        albumTitle.text = song.albumTitle
        timeRemaining.text = String(Double(song.playbackDuration))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI(with: nowPlaying)
        player = MPMusicPlayerApplicationController.applicationQueuePlayer
        playOrPause = false // not playing
        collection = MPMediaItemCollection(items: [nowPlaying])
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
            if let ppc = segue.destination.popoverPresentationController{
                ppc.delegate = self
            }
        }
        
    }
    
    @IBAction func exitCurrPlaying(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func playPaulse(_ sender: UIButton) {
        player.setQueue(with: collection)
        player.prepareToPlay()
        playOrPause ? player.pause() : player.play()
        playOrPause = !playOrPause
    }
    
    @IBAction func nextSong(_ sender: UIButton) {
        player.skipToNextItem()
        playOrPause = true
        player.play()
    }
    
    @IBAction func prevSong(_ sender: UIButton) {
        player.skipToPreviousItem()
        playOrPause = true
        player.play()
    }
    // change presentation behavior for popover in landscape and portrait mode
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact{ // landscape mode, do not adapt
            return .none
        } else if traitCollection.horizontalSizeClass == .compact{ //portrait mode
            return .fullScreen
        }
        return .none
    }
    
}

