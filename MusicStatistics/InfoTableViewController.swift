//
//  InfoTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/28/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class InfoTableViewController: UITableViewController {
    var info:MPMediaItem!
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MMM-dd-yyyy hh:mm"
        dateFormatter.timeZone = TimeZone.current
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
        return 14
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UIScreen.main.bounds.size.width
        }
        return UITableViewAutomaticDimension
    }

    @IBAction func leaveInfo(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {//1
            let cell = tableView.dequeueReusableCell(withIdentifier: "img", for: indexPath)
            if let imgcell = cell as? InfoImageTableViewCell{
                imgcell.updateAlbumArt(with: info)
            }
            return cell
        }

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "misc", for: indexPath)
        switch row {
        case 1: // 2
            cell.textLabel?.text = "Title"
            cell.detailTextLabel?.text = info.title
        case 2: // 3
            cell.textLabel?.text = "Artist"
            cell.detailTextLabel?.text = info.artist
        case 3: // 4
            cell.textLabel?.text = "Album"
            cell.detailTextLabel?.text = info.albumTitle
        case 4: // 5
            cell.textLabel?.text = "Track #"
            cell.detailTextLabel?.text = "\(info.albumTrackNumber)"
        case 5: // 6
            cell.textLabel?.text = "Composer"
            cell.detailTextLabel?.text = info.composer
        case 6: // 7
            cell.textLabel?.text = "Genre"
            cell.detailTextLabel?.text = info.genre
        case 7: //8
            cell.textLabel?.text = "Date Added"
            cell.detailTextLabel?.text = dateFormatter.string(from: info.dateAdded)
        case 8: // 9
            cell.textLabel?.text = "Last Played"
            var lpdate: String!
            if info.lastPlayedDate == nil { lpdate = "N/A" }
            else { lpdate = dateFormatter.string(from: info.lastPlayedDate ?? Date())}
            cell.detailTextLabel?.text = lpdate
        case 9: // 10
            cell.textLabel?.text = "Released"
            var rd:String!
            if info.releaseDate == nil { rd = "N/A"}
            else {rd = dateFormatter.string(from: info.releaseDate ?? Date())}
            cell.detailTextLabel?.text = rd
        case 10:
            cell.textLabel?.text = "Beats Per Minute"
            cell.detailTextLabel?.text = info.beatsPerMinute == 0 ? "Unknown" : "\(info.beatsPerMinute)"
        case 11:
            cell.textLabel?.text = "Explicit?"
            cell.detailTextLabel?.text = info.isExplicitItem ? "✅" : "❌"
        case 12: // 13
            cell.textLabel?.text = "Play Count"
            cell.detailTextLabel?.text = "\(info.playCount)"
        case 13: // 14
            cell.textLabel?.text = "Skip Count"
            cell.detailTextLabel?.text = "\(info.skipCount)"
        default:
            break
        }
        return cell
    }
 

}
