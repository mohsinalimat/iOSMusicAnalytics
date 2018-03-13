//
//  PlaylistSongsTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 3/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistSongsTableViewController: UITableViewController {
    var requestedSongs: [MPMediaItem]! = []
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
        return requestedSongs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = indexPath.row
        if requestedSongs.count - currentIndex < 30{
            appDelegate.currentQueue = Array(requestedSongs[currentIndex...(requestedSongs.count-1)])
        } else {
            appDelegate.currentQueue = Array(requestedSongs[currentIndex...(currentIndex+30)])
        }
        if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
            tabbar.selectedIndex = 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistContent", for: indexPath)
        cell.textLabel?.text = requestedSongs[indexPath.row].title ?? "Unknown"
        cell.detailTextLabel?.text = requestedSongs[indexPath.row].artist ?? "Unknown"
        cell.imageView?.image = getArtworkIconWithDefaults(using: requestedSongs[indexPath.row])
        return cell
    }
    
}
