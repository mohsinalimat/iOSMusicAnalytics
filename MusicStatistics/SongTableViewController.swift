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
        cell.detailTextLabel?.text = songs[indexPath.row].artist
        cell.imageView?.image = songs[indexPath.row].artwork?.image(at: CGSize(width:30,height:30))

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
    }
}

