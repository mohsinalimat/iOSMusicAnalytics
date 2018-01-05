//
//  QueueTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/4/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class QueueTableViewController: UITableViewController {
    var appDelegate: AppDelegate!
    //var songs: [MPMediaItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Queue"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.setEditing(true, animated: true)
        
    }
   
    @IBAction func leaveQueue(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
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
        return appDelegate.currentQueue.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueItem", for: indexPath)

        cell.textLabel?.text = appDelegate.currentQueue[indexPath.row].title
        let artistInfo = (appDelegate.currentQueue[indexPath.row].artist ?? "")
        let albumInfo =  " · " + (appDelegate.currentQueue[indexPath.row].albumTitle ?? "")
        let genreInfo = " · " + (appDelegate.currentQueue[indexPath.row].genre ?? "")
        cell.detailTextLabel?.text = artistInfo + albumInfo + genreInfo
        cell.imageView?.image = appDelegate.currentQueue[indexPath.row].artwork?.image(at: CGSize(width:30,height:30))
        cell.showsReorderControl = true


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
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedSong = appDelegate.currentQueue[fromIndexPath.row]
        appDelegate.currentQueue.remove(at: fromIndexPath.row)
        appDelegate.currentQueue.insert(movedSong, at: to.row)
        tableView.reloadData()
    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
