//
//  SearchSongsTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/19/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class SearchSongsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var allSongs: [MPMediaItem]!
    let searchController = UISearchController(searchResultsController: nil)
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        allSongs = MPMediaQuery.songs().items ?? []
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "Search My Songs"
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.placeholder = "Search for Songs"
        searchController.searchBar.keyboardAppearance = .dark
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.orange
        tableView.tableHeaderView = searchController.searchBar
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
        return allSongs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songsSearchCell", for: indexPath)

        // Configure the cell...
        let currSong = allSongs[indexPath.row]
        cell.textLabel?.text = currSong.title
        let artistInfo = (currSong.artist ?? "Unknown")
        let albumInfo =  " · " + (currSong.albumTitle ?? "Unknown")
        let genreInfo = " · " + (currSong.genre ?? "Unknown")
        cell.detailTextLabel?.text = artistInfo + albumInfo + genreInfo
        if currSong.artwork != nil {
            cell.imageView?.image = currSong.artwork?.image(at: CGSize(width:30,height:30))
        } else {
            cell.imageView?.image = UIImage(named: "guitarIcon")
        }

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, !allSongs.isEmpty{
            let songNameFilter = MPMediaPropertyPredicate(value: searchText, forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.contains)
            let myFilter: Set<MPMediaPropertyPredicate> = [songNameFilter]
            allSongs = MPMediaQuery(filterPredicates: myFilter).items ?? []
//            searchedSongs = allSongs.filter({($0.title?.contains(searchText))!})
            if allSongs.isEmpty { allSongs = MPMediaQuery.songs().items ?? [] }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allSongs.isEmpty { return }
        let currentIndex = indexPath.row
        if allSongs.count - currentIndex < 30{
            appDelegate.currentQueue = Array(allSongs[currentIndex...(allSongs.count-1)])
        } else {
            appDelegate.currentQueue = Array(allSongs[currentIndex...(currentIndex+30)])
        }
        if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
            tabbar.selectedIndex = 2
        }
    }
    
}
