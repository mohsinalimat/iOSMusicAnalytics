//
//  SongTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate{

    var songs:[MPMediaItem] = []
    var unfilteredSongs:[MPMediaItem] = []
    var songSections: [[MPMediaItem]] = []
    var sortMode:String!
    var lastSong:MPMediaItem? = nil
    var appDelegate: AppDelegate!
    let playController = PlayerViewController()
    //@IBOutlet weak var songSearchBar: UISearchBar!
    var searchController: UISearchController!
    var sectionTitles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Songs"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        unfilteredSongs = MPMediaQuery.songs().items ?? []
        (songSections, sectionTitles) = sortIntoSongSections(with: unfilteredSongs, and: "Title")
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
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songSections[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalNumberSongsInSection = songSections[indexPath.section].count - 1
        appDelegate.currentQueue = Array(songSections[indexPath.section][indexPath.row...totalNumberSongsInSection])
        if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
            tabbar.selectedIndex = 2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath)

        // Configure the cell...
        let currSong = songSections[indexPath.section][indexPath.row]
        cell.textLabel?.text = currSong.title
        let artistInfo = (currSong.artist ?? "Unknown")
        let albumInfo =  " · " + (currSong.albumTitle ?? "Unknown")
        let genreInfo = " · " + (currSong.genre ?? "Unknown")
        cell.detailTextLabel?.text = artistInfo + albumInfo + genreInfo
        cell.imageView?.image = getArtworkIconWithDefaults(using: currSong)
        return cell
    }
    
    @IBAction func updateSortingMode(from segue:UIStoryboardSegue){
        var tempQuery: [MPMediaItem]!
        if let result = segue.source as? SortSongsViewController{
            if sortMode != result.currentSortingMode{ // only reload data when different
                sortMode = result.currentSortingMode
                switch sortMode{
                    case "Title": tempQuery = MPMediaQuery.songs().items ?? []
                    case "Artist": tempQuery = MPMediaQuery.artists().items ?? []
                    case "Album": tempQuery = MPMediaQuery.albums().items ?? []
                    case "Genre": tempQuery = MPMediaQuery.genres().items ?? []
                    default: break
                }
                (songSections, sectionTitles) = sortIntoSongSections(with: tempQuery, and: sortMode)
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
 
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
        headerView.contentView.backgroundColor = UIColor.lightText
        //headerView.textLabel?.textColor = UIColor.orange
        return headerView
    }
}
