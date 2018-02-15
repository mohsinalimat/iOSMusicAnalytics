//
//  ViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreData

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
    //var player:MPMusicPlayerApplicationController!
    let player = MPMusicPlayerController.systemMusicPlayer
    var isPlayerLoaded = false
    var timer: Timer!
    var beginPlaying: Bool!
    var appDelegate: AppDelegate!
    var isFirstSongTheSame = false
    var returnFromQueueEditor = false
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var isViewingLyrics: Bool!
    var songNameInDB:String!
    var doesLyricsExist = false
    
    var playOrPause: Bool!{
        didSet{
            if playOrPause { // play -> pause
                playButton.setImage(UIImage(named: "Pause Button"), for: .normal)
            } else { // pause -> play
                playButton.setImage(UIImage(named: "Play Button"), for: .normal)
            }
        }
    }
    
    
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
        songProgress.isContinuous = false
        background.clipsToBounds = true
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
        updatePlaybackStatus()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared, queue: OperationQueue.main){ _ in
            self.checkAndUpdatePlayerInfo()
            self.updatePlaybackStatus()
        }
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    public func updateUI(with song:MPMediaItem?){
        if song != nil{
            let frame = UIScreen.main.bounds.size
            let artworkSize:CGSize = CGSize(width: frame.width, height: frame.width)
            let artwork = song!.artwork
            songTitle.text = song!.title ?? "Unknown"
            albumTitle.text = song!.albumTitle ?? "Unknown"
            if song!.title == "" {songTitle.text = "Unknown"}
            if song!.albumTitle == "" {albumTitle.text = "Unknown"}
            timeRemaining.text = timeIntervalToReg(song!.playbackDuration)
            //player = MPMusicPlayerApplicationController.applicationQueuePlayer
            playOrPause = false // not playing
            nowPlaying = song
            
            if song?.artwork?.image != nil {
                albumArt?.image = artwork?.image(at: artworkSize)
            } else{
                albumArt?.image = UIImage(named: "guitar")
            }
            
            background.removeBlurEffect()
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
        if let dest = destinationViewController as? LyricsViewController{
            dest.isViewing = isViewingLyrics
            dest.searchItem = songNameInDB
            if doesLyricsExist { dest.existingLyrics = nowPlaying.lyrics! }
            dest.navigationItem.title = nowPlaying.title ?? "Unknown"
        }
    }
    
    @IBAction func playPause(_ sender: UIButton) {
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
    
    // alter volume or add/view lyrics
    @IBAction func additionalSongActions(_ sender: UIButton) {
        let alertController = UIAlertController(title: "\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = myOrange()
        
        let volBounds =  CGRect(x: 10.0, y: 13.0, width: alertController.view.bounds.size.width-50, height: 20)
        //let volBounds =  CGRect(x: 10.0, y: 13.0, width: 280, height: 20)
        let volumeController = MPVolumeView(frame: volBounds)
        volumeController.showsRouteButton = false
        volumeController.tintColor = UIColor(red: 1, green: 132/255, blue: 23/255, alpha: 1)
        if let volumeSliderView =  volumeController.subviews.first as? UISlider {
            volumeSliderView.minimumValueImage = UIImage(named: "volumeIconLow")
            volumeSliderView.maximumValueImage = UIImage(named: "volumeIcon")
        }
        alertController.view.addSubview(volumeController)
        
        if let presenter = alertController.popoverPresentationController{
            // ensure proper functionality on iPad
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        //find lyric - view lyrics - not found - create lyrics
        var lyricsAction:UIAlertAction!
        // lyrics not found in m4a, create and store in core data
        if nowPlaying.lyrics == nil || nowPlaying.lyrics!.isEmpty {
            doesLyricsExist = false
            songNameInDB = (nowPlaying.title ?? "") + (nowPlaying.albumTitle ?? "")
            let obtainedLyrics = Song.getLyrics(using: songNameInDB, in: container!.viewContext)
            if obtainedLyrics == "No Matches"{ // create lyrics w/o option to delete
                lyricsAction = UIAlertAction(title: "Add Lyrics", style: .default){ _ in
                    DispatchQueue.main.async { [weak self] in
                        self?.isViewingLyrics = false
                        self?.performSegue(withIdentifier: "lyricsAction", sender: self)
                    }
                }
            } else { // view Lyrics with delete functionality
                lyricsAction = UIAlertAction(title: "View Lyrics", style: .default){ _ in
                    DispatchQueue.main.async { [weak self] in
                        self?.isViewingLyrics = true
                        self?.performSegue(withIdentifier: "lyricsAction", sender: self)
                    }
                }
                let deleteLyricsAction = UIAlertAction(title: "Delete Lyrics", style: .destructive) { _ in
                    Song.deleteLyrics(using: self.songNameInDB, in: self.container!.viewContext)
                    overlayTextWithVisualEffect(using: "Success", on: self.view)
                }
                alertController.addAction(deleteLyricsAction)
            }
        } else{ // view present lyrics
            lyricsAction = UIAlertAction(title: "View Lyrics", style: .default){ _ in
                DispatchQueue.main.async { [weak self] in
                    self?.doesLyricsExist = true
                    self?.performSegue(withIdentifier: "lyricsAction", sender: self)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(lyricsAction)
        
//        let subview = alertController.view.subviews.first!
//        let alertContentView = subview.subviews.last!
//        for bg in alertContentView.subviews{
//            bg.backgroundColor = UIColor.darkGray
//            bg.layer.cornerRadius = 15.0
//        }
        
        present(alertController, animated: true)
    }
    
    @IBAction func updatePlayingQueue(with segue:UIStoryboardSegue){
        if let _ = segue.source as? QueueTableViewController{
            returnFromQueueEditor = true
        }
    }
    
    func updatePlaybackStatus(){
        switch player.playbackState{
        case .paused, .stopped:
            playOrPause = false
        case .playing:
            playOrPause = true
        default: break;
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

