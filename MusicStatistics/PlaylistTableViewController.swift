//
//  PlaylistTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 2/27/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistTableViewController: UITableViewController {
    var allItems: [MPMediaPlaylist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allPlaylists = MPMediaQuery.playlists()
        let collections = allPlaylists.collections
        for collection in collections!{
            if let playlist = collection as? MPMediaPlaylist{
                allItems.append(playlist)
            }
        }
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
        return allItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistItem", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = allItems[indexPath.row].name
        //let author = allItems[indexPath.row].authorDisplayName ?? "Nothing"
        let songCount = allItems[indexPath.row].items.count
        cell.detailTextLabel?.text =  songCount != 1 ? "\(songCount) Songs": "1 Song"
        cell.imageView?.image = getArtworkIconWithDefaults(using: allItems[indexPath.row].items.first)
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "playlistSegue"{
            guard let selectedIndex = tableView.indexPathForSelectedRow?.row else { return false }
            if allItems[selectedIndex].items.count == 0 {
                let alert = UIAlertController(title: "No Songs", message: "This playlist contains no songs. Try adding music to playlists in the default music app", preferredStyle: .alert)
                alert.view.tintColor = myOrange()
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let dest = destinationViewController as? PlaylistSongsTableViewController{
            dest.requestedSongs = allItems[tableView.indexPathForSelectedRow!.row].items
            dest.navigationItem.title = allItems[tableView.indexPathForSelectedRow!.row].name
        }
    }
    

}
