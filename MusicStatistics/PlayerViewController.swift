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
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var shuffleIcon: UIButton!
    @IBOutlet weak var repeatIcon: UIButton!
    @IBOutlet weak var songProgress: UISlider!
    @IBOutlet weak var background: UIImageView!
    
    var nowPlaying: MPMediaItem!
    var player:MPMusicPlayerApplicationController!
    var playOrPause: Bool!
    var isPlayerLoaded = false
    var timer: Timer!
    var beginPlaying: Bool!
    var appDelegate: AppDelegate!
    var isFirstSongTheSame = false
    var returnFromQueueEditor = false
    
    var collection:MPMediaItemCollection!{
        didSet{
            var playHead: TimeInterval!
            if isFirstSongTheSame { playHead = player.currentPlaybackTime }
            player.setQueue(with: collection)
            player.prepareToPlay()
            if isFirstSongTheSame && returnFromQueueEditor {
                player.currentPlaybackTime = playHead
                isFirstSongTheSame = false
                returnFromQueueEditor = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Do any additional setup after loading the view, typically from a nib.
        updateUI(with: appDelegate.currentQueue.isEmpty ? MPMediaQuery.songs().items!.randomItem()! : appDelegate.currentQueue.first)
        updateQueue()
        beginPlaying = false
        isPlayerLoaded = true
        player.shuffleMode = .off
        player.repeatMode = .none
        songProgress.setThumbImage(UIImage(named:"playerThumb"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPlayerLoaded && !appDelegate.currentQueue.isEmpty{
            if collection.items.first == appDelegate.currentQueue.first{
                isFirstSongTheSame = true
            }
            if collection.items != appDelegate.currentQueue{
                updateUI(with: appDelegate.currentQueue.first)
                updateQueue()
            }
        }
        checkAndUpdatePlayerInfo()
        NotificationCenter.default.addObserver(self, selector:#selector(PlayerViewController.checkAndUpdatePlayerInfo),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        // called when the application terminates -> stop the player
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillTerminate, object: UIApplication.shared, queue: OperationQueue.main)
        { _ in self.player.stop() }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: UIApplication.shared, queue: OperationQueue.main)
        { _ in if self.beginPlaying { self.timer.invalidate() } }
    }
    
    @objc func checkAndUpdatePlayerInfo(){
        if player.nowPlayingItem != nowPlaying { updateUI(with: player.nowPlayingItem) }
        if beginPlaying && !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updatePlaybackTime), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public func updateUI(with song:MPMediaItem?){
        if song != nil{
            let frame = UIScreen.main.bounds.size
            let artworkSize:CGSize = CGSize(width: frame.width, height: frame.width)
            let artwork = song!.artwork
            albumArt?.image = artwork?.image(at: artworkSize)
            songTitle.text = song!.title ?? "None"
            albumTitle.text = song!.albumTitle ?? "None"
            timeRemaining.text = timeIntervalToReg(song!.playbackDuration)
            player = MPMusicPlayerApplicationController.applicationQueuePlayer
            playOrPause = false // not playing
            nowPlaying = song
            
            background.image = nil
            background.image = artwork?.image(at: artworkSize)
            background.addBlurEffect()
            
        }
    }
    
    func updateQueue(){
        if appDelegate.currentQueue.isEmpty{
            appDelegate.currentQueue = [nowPlaying]
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
    
    @IBAction func songProgressChanged(_ sender: UISlider) {
        let totalTime = player.nowPlayingItem?.playbackDuration ?? 240.0
        player.currentPlaybackTime = Double(sender.value) * totalTime
    }
    
    @objc func updatePlaybackTime(){
        let currTime = player.currentPlaybackTime
        let totalTime = player.nowPlayingItem?.playbackDuration ?? 240.0
        if !currTime.isNaN {
            currentTime.text = timeIntervalToReg(currTime)
            timeRemaining.text = timeIntervalToReg(totalTime - currTime)
            songProgress.setValue(Float(currTime/totalTime), animated: true)
            // update UI when queue automatically skips to next
            if Int(currTime) == 0 {updateUI(with: player.nowPlayingItem!)}
        }
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
    
    @IBAction func playPause(_ sender: UIButton) {
        playOrPause ? player.pause() : player.play()
        playOrPause = !playOrPause
        if !beginPlaying {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updatePlaybackTime), userInfo: nil, repeats: true)
            beginPlaying = true
        }
        if playOrPause { // play -> pause
            playButton.setImage(UIImage(named: "Pause Button"), for: .normal)
        } else { // pause -> play
          playButton.setImage(UIImage(named: "Play Button"), for: .normal)
        }
    }
    
    @IBAction func nextSong(_ sender: UIButton) {
        player.skipToNextItem()
        updateUI(with: player.nowPlayingItem!)
        playOrPause = true
        player.play()
    }
    
    @IBAction func prevSong(_ sender: UIButton) {
        player.currentPlaybackTime > 10.0 ? player.skipToBeginning() : player.skipToPreviousItem()
        updateUI(with: player.nowPlayingItem!)
        playOrPause = true
        player.play()
    }
    
    @IBAction func changeShuffleMode(_ sender: UIButton) {
        if player.shuffleMode == .off{
            player.shuffleMode = .songs
            shuffleIcon.tintColor = UIColor.orange
        } else if player.shuffleMode == .songs{
            player.shuffleMode = .off
            shuffleIcon.tintColor = UIColor.white
        }
        
    }
    @IBAction func changeRepeatMode(_ sender: UIButton) {
        if player.repeatMode == .none{
            player.repeatMode = .all
            repeatIcon.tintColor = UIColor.orange
        } else if player.repeatMode == .all {
            player.repeatMode = .one
            repeatIcon.setImage(UIImage(named: "repeatIcon2"), for: .normal)
        } else if player.repeatMode == .one{
            player.repeatMode = .none
            repeatIcon.setImage(UIImage(named: "repeatIcon1"), for: .normal)
            repeatIcon.tintColor = UIColor.white
        }
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
    
    @IBAction func alterVolume(_ sender: UIButton) {
        let alertController = UIAlertController(title: "\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor(red: 1, green: 132/255, blue: 23/255, alpha: 1)
        
        let volBounds =  CGRect(x: 10.0, y: 13.0, width: alertController.view.bounds.size.width-50, height: 20)
        let volumeController = MPVolumeView(frame: volBounds)
        volumeController.tintColor = UIColor(red: 1, green: 132/255, blue: 23/255, alpha: 1)
        alertController.view.addSubview(volumeController)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func updatePlayingQueue(with segue:UIStoryboardSegue){
        if let _ = segue.source as? QueueTableViewController{
            returnFromQueueEditor = true
        }
    }
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

