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
    let dateFormatter = DateFormatter()
    var infoData: [(String,String?)] = []
    var info:MPMediaItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MMM-dd-yyyy hh:mm"
        dateFormatter.timeZone = TimeZone.current
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        infoData.append(("Title",info.title))
        infoData.append(("Artist",info.artist))
        infoData.append(("Track #",info.albumTitle))
        infoData.append(("Composer",info.composer))
        infoData.append(("Genre",info.genre))
        infoData.append(("Data Added",dateFormatter.string(from: info.dateAdded)))
        let lp = info.lastPlayedDate != nil ? dateFormatter.string(from: info.lastPlayedDate!) : nil
        infoData.append(("Last Played", lp))
        let rd = info.releaseDate != nil ? dateFormatter.string(from: info.releaseDate!) : nil
        infoData.append(("Release Date",rd))
        infoData.append(("Beats Per Minute", info.beatsPerMinute != 0 ? "\(info.beatsPerMinute)" : nil))
        infoData.append(("Explicit", info.isExplicitItem ? "✅" : "❎"))
        infoData.append(("Play Count", "\(info.playCount)"))
        infoData.append(("Skip Count", "\(info.skipCount)"))
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
        return infoData.count
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

//        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "misc", for: indexPath)
//        switch row {
//        case 1: // 2
//            cell.textLabel?.text = "Title"
//            cell.detailTextLabel?.text = info.title
//        case 2: // 3
//            cell.textLabel?.text = "Artist"
//            cell.detailTextLabel?.text = info.artist
//        case 3: // 4
//            cell.textLabel?.text = "Album"
//            cell.detailTextLabel?.text = info.albumTitle
//        case 4: // 5
//            cell.textLabel?.text = "Track #"
//            cell.detailTextLabel?.text = "\(info.albumTrackNumber)"
//        case 5: // 6
//            cell.textLabel?.text = "Composer"
//            cell.detailTextLabel?.text = info.composer
//        case 6: // 7
//            cell.textLabel?.text = "Genre"
//            cell.detailTextLabel?.text = info.genre
//        case 7: //8
//            cell.textLabel?.text = "Date Added"
//            cell.detailTextLabel?.text = dateFormatter.string(from: info.dateAdded)
//        case 8: // 9
//            cell.textLabel?.text = "Last Played"
//            var lpdate: String!
//            if info.lastPlayedDate == nil { lpdate = "N/A" }
//            else { lpdate = dateFormatter.string(from: info.lastPlayedDate ?? Date())}
//            cell.detailTextLabel?.text = lpdate
//        case 9: // 10
//            cell.textLabel?.text = "Released"
//            var rd:String!
//            if info.releaseDate == nil { rd = "N/A"}
//            else {rd = dateFormatter.string(from: info.releaseDate ?? Date())}
//            cell.detailTextLabel?.text = rd
//        case 10:
//            cell.textLabel?.text = "Beats Per Minute"
//            cell.detailTextLabel?.text = info.beatsPerMinute == 0 ? "N/A" : "\(info.beatsPerMinute)"
//        case 11:
//            cell.textLabel?.text = "Explicit?"
//            cell.detailTextLabel?.text = info.isExplicitItem ? "✅" : "❎"
//        case 12: // 13
//            cell.textLabel?.text = "Play Count"
//            cell.detailTextLabel?.text = "\(info.playCount)"
//        case 13: // 14
//            cell.textLabel?.text = "Skip Count"
//            cell.detailTextLabel?.text = "\(info.skipCount)"
//        default:
//            breakinfoData.append(("Play Count", "\(info.playCount)"))
//        }
        cell.textLabel?.text = infoData[indexPath.row - 1].0
        cell.detailTextLabel?.text = infoData[indexPath.row - 1].1 ?? "N/A"
        return cell
    }
 

}
