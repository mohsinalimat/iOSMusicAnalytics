//
//  SongTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/27/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: UITableViewController {
    var songs:[MPMediaItem] = []
    var sortMode:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Songs"
        let status = MPMediaLibrary.authorizationStatus()
        if status == .notDetermined{
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized{ print("authroized") }
            }
        }
        songs = MPMediaQuery.songs().items!
        sortMode = "Title" // initialize at title sorting mode
        
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = songs[indexPath.row].title
        cell.detailTextLabel?.text = (songs[indexPath.row].artist ?? "") + " · " + (songs[indexPath.row].albumTitle ?? "")
        cell.imageView?.image = songs[indexPath.row].artwork?.image(at: CGSize(width:30,height:30))

        return cell
    }
    
    @IBAction func updateSortingMode(from segue:UIStoryboardSegue){
        if let result = segue.source as? SortSongsViewController{
            if sortMode != result.currentSortingMode{ // only reload data when different
                sortMode = result.currentSortingMode
                switch sortMode{
                case "Title":
                    songs = MPMediaQuery.songs().items!
                case "Artist":
                    songs = MPMediaQuery.albums().items!
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
                dest.navigationItem.title = songs[selectedIndex.row].title
                dest.nowPlaying = songs[selectedIndex.row]
            }
            
        }
        if let dest = destinationViewController as? SortSongsViewController{
            dest.currentSortingMode = sortMode
        }
    }
}

