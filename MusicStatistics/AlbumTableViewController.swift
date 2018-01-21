//
//  AlbumTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/30/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumTableViewController: UITableViewController {
    var albumContents: [MPMediaItem]!
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
        return albumContents.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumInfo", for: indexPath)
            if let infoCell = cell as? AlbumInfoTableViewCell{
                infoCell.updateAlbumInfo(with: albumContents.last!)
            }
            return cell
        }

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "songPerAlbum", for: indexPath)
        let trackNumber = String(albumContents[indexPath.row - 1].albumTrackNumber) 
        let trackTitle = albumContents[indexPath.row - 1].title ?? ""
        let duration = timeIntervalToReg(albumContents[indexPath.row - 1].playbackDuration)
        let spacing = trackNumber.count == 1 ? "        " : "       "
        cell.textLabel?.text = trackNumber + spacing + trackTitle
        cell.detailTextLabel?.text = String(duration)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { //for the album info cell
            return UIScreen.main.bounds.size.width
        }
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            appDelegate.currentQueue = Array(albumContents[indexPath.row - 1..<albumContents.count])
            if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
                tabbar.selectedIndex = 2
            }
        }
    }
}
