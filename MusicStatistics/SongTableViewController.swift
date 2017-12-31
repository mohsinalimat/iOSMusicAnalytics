//
//  SongTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var songs:[MPMediaItem] = []
    var sortMode:String!
    var lastSong:MPMediaItem? = nil
    var appDelegate: AppDelegate!
    let playController = PlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Songs"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        songs = MPMediaQuery.songs().items ?? []
        sortMode = "Title" // initialize at title sorting mode
        self.popoverPresentationController?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.currentQueue = Array(songs[indexPath.row...songs.count-1])
        self.navigationController?.setToolbarHidden(false, animated: true)
        //playController.updateUI(with: songs[indexPath.row])
        
    }

    @IBAction func moveToPlayer(_ sender: UIBarButtonItem) {
        if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
            tabbar.selectedIndex = 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = songs[indexPath.row].title
        let artistInfo = (songs[indexPath.row].artist ?? "")
        let albumInfo =  " · " + (songs[indexPath.row].albumTitle ?? "")
        let genreInfo = " · " + (songs[indexPath.row].genre ?? "")
        cell.detailTextLabel?.text = artistInfo + albumInfo + genreInfo
        cell.imageView?.image = songs[indexPath.row].artwork?.image(at: CGSize(width:30,height:30))

        return cell
    }
    
    @IBAction func updateSortingMode(from segue:UIStoryboardSegue){
        if let result = segue.source as? SortSongsViewController{
            if sortMode != result.currentSortingMode{ // only reload data when different
                sortMode = result.currentSortingMode
                switch sortMode{
                case "Title":
                    songs = MPMediaQuery.songs().items ?? []
                case "Artist":
                    songs = MPMediaQuery.artists().items ?? []
                case "Album":
                    songs = MPMediaQuery.albums().items ?? []
                case "Genre":
                    songs = MPMediaQuery.genres().items ?? []
                default:
                    break
                }
                tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
                destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let dest = destinationViewController as? PlayerViewController{
            if let selectedIndex = tableView.indexPathForSelectedRow{
                //dest.navigationItem.title = songs[selectedIndex.row].title
                lastSong = songs[selectedIndex.row]
                dest.nowPlaying = songs[selectedIndex.row]
            } else if segue.identifier == "toolbar"{
                dest.nowPlaying = lastSong!
            }
            
        }
        if let dest = destinationViewController as? SortSongsViewController{
            dest.currentSortingMode = sortMode
            if let ppc = segue.destination.popoverPresentationController{
                ppc.delegate = self
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toolbar" && lastSong == nil{ return false }
        return true
    }
    
    // change presentation behavior for popover in landscape and portrait mode
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

