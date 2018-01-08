//
//  SongTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate,UISearchResultsUpdating {

    var songs:[MPMediaItem] = []
    var unfilteredSongs:[MPMediaItem] = []
    var sortMode:String!
    var lastSong:MPMediaItem? = nil
    var appDelegate: AppDelegate!
    let playController = PlayerViewController()
    //@IBOutlet weak var songSearchBar: UISearchBar!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Songs"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        unfilteredSongs = MPMediaQuery.songs().items ?? []
        songs = unfilteredSongs
        sortMode = "Title" // initialize at title sorting mode
        self.popoverPresentationController?.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.placeholder = "Search for Songs"
        searchController.searchBar.keyboardAppearance = .dark
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.orange
        tableView.tableHeaderView = searchController.searchBar
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.currentQueue = Array(songs[indexPath.row..<songs.count])
        self.navigationController?.setToolbarHidden(false, animated: true)
        //playController.updateUI(with: songs[indexPath.row])
        //appDelegate.currentQueue = Array(albumContents[indexPath.row - 1..<albumContents.count])
        if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
            tabbar.selectedIndex = 2
        }
        
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
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, !songs.isEmpty{
            songs = unfilteredSongs.filter({($0.title?.contains(searchText))!})
        } else {
            songs = unfilteredSongs
        }
        tableView.reloadData()
    }
    
    /*
    private func sortIntoAlphabeteticalSongs(with allSongs:[MPMediaItem]) -> [[MPMediaItem]]{
        var results: [[MPMediaItem]] = []
        var tempCollection: [MPMediaItem] = []
        var count = 0
        var currentLetter: Character!
        var prevLetter: Character!
        for item in allSongs{
            if count == 0{
                prevLetter = item.title?.first
                count += 1
            }
        }
        return results
    }
    
    private func findFirstAlpha(with text:String) -> Character{
        let letters = CharacterSet.letters
        if text.starts(with: "The ") && text.count > 4{
            return text[4]
        }
        for char in text{
            if letters.contains(char.unicodeScalars) {return char}
        }
        return " "
    }
     */
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

