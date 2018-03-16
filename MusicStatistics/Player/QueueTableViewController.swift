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
    var titleToDivideSections: String!
    var dividedSections: [[MPMediaItem]] = [[],[],[]]
    var sectionTitles = ["Previous Songs","Now Playing","Upcoming Songs"]
    var indexInQueue: Int! = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Queue"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        //load the data structure
        DispatchQueue.global(qos: .userInitiated).async {
            self.dividedSections = divideMusicQueueIntoSections(using: self.appDelegate.currentQueue, andTitle: self.titleToDivideSections)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexToScrollTo = IndexPath(row: 0, section: 1)
                self.tableView.scrollToRow(at: indexToScrollTo, at: .top , animated: true)
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dividedSections[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueItem", for: indexPath)

        cell.textLabel?.text = dividedSections[indexPath.section][indexPath.row].title
        let artistInfo = (dividedSections[indexPath.section][indexPath.row].artist ?? "")
        let albumInfo =  " · " + (dividedSections[indexPath.section][indexPath.row].albumTitle ?? "")
        let genreInfo = " · " + (dividedSections[indexPath.section][indexPath.row].genre ?? "")
        cell.detailTextLabel?.text = artistInfo + albumInfo + genreInfo
        cell.imageView?.image = getArtworkIconWithDefaults(using: dividedSections[indexPath.section][indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexInQueue = convertQueneIndex(using: indexPath, with: dividedSections)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "updateQueue", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
        headerView.contentView.backgroundColor = UIColor.lightText
        return headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let _ = destinationViewController as? PlayerViewController{
            // the indexInQueue must be the current index
            if indexInQueue == -1 { // not selected
                let nowPlayingIndex = IndexPath(row: 0, section: 1)
                indexInQueue = convertQueneIndex(using: nowPlayingIndex, with: dividedSections)
            }
        }
    }

}
