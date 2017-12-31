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
    var appDelegate: AppDelegate!
    var timer: Timer!
    var beginPlaying: Bool!
    
    
    public func updateUI(with song:MPMediaItem){
        let frame = UIScreen.main.bounds.size
        let artworkSize:CGSize = CGSize(width: frame.width, height: frame.width)
        let artwork = song.artwork
        albumArt?.image = artwork?.image(at: artworkSize)
        songTitle.text = song.title ?? "None"
        albumTitle.text = song.albumTitle ?? "None"
        //print(song.title! + " " + song.albumTitle!)
        timeRemaining.text = timeIntervalToReg(song.playbackDuration)
        player = MPMusicPlayerApplicationController.applicationQueuePlayer
        playOrPause = false // not playing
        nowPlaying = song
        if appDelegate.currentQueue.isEmpty{
            //collection = MPMediaItemCollection(items: MPMediaQuery.songs().items!)
            collection = MPMediaItemCollection(items: [nowPlaying])
        } else {
            collection = MPMediaItemCollection(items: appDelegate.currentQueue)
        }
    }
    
    func timeIntervalToReg(_ interval:TimeInterval) -> String{
        let minute = String(Int(interval) / 60)
        var seconds = String(Int(interval) % 60)
        if seconds.count == 1 {seconds = "0" + seconds}
        return minute + ":" + seconds
    }
    
    @objc func updatePlaybackTime(){
        let currTime = player.currentPlaybackTime
        let totalTime = (player.nowPlayingItem?.playbackDuration)!
        currentTime.text = timeIntervalToReg(currTime)
        timeRemaining.text = timeIntervalToReg(totalTime - currTime)
        songProgress.progress = Float(currTime/totalTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Do any additional setup after loading the view, typically from a nib.
        updateUI(with: appDelegate.currentQueue.isEmpty ? MPMediaQuery.songs().items!.randomItem()! : appDelegate.currentQueue[0])
        beginPlaying = false
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
    
    @IBAction func playPaulse(_ sender: UIButton) {
        player.setQueue(with: collection)
        player.prepareToPlay()
        playOrPause ? player.pause() : player.play()
        playOrPause = !playOrPause
        if !beginPlaying {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updatePlaybackTime), userInfo: nil, repeats: true)
            beginPlaying = true
        }
    }
    
    @IBAction func nextSong(_ sender: UIButton) {
        player.skipToNextItem()
        updateUI(with: player.nowPlayingItem!)
        playOrPause = true
        player.play()
    }
    
    @IBAction func prevSong(_ sender: UIButton) {
        player.skipToPreviousItem()
        updateUI(with: player.nowPlayingItem!)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

