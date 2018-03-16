//
//  AnalyticsDetailTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AnalyticsDetailTableViewController: UITableViewController {
    var requestedSongs: [MPMediaItem]! = []
    var mode: String!
    let dateFormatter = DateFormatter()
    var appDelegate: AppDelegate!
    @IBOutlet weak var analyticsLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsLoading.startAnimating()
        let allSongs = MPMediaQuery.songs().items ?? []
        dateFormatter.dateFormat = "MMM dd"
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.global(qos: .userInitiated).async{
            switch self.mode{
            case "Most Listened Songs":
                if !self.requestedSongs.isEmpty{
                    self.requestedSongs.sort(by: {$0.playCount > $1.playCount})
                } else {
                    self.requestedSongs = allSongs.sorted(by: {$0.playCount > $1.playCount})
                }
            case "Least Listened Songs":
                self.requestedSongs = allSongs.sorted(by: {$0.playCount < $1.playCount})
            case "Most Skipped Songs":
                self.requestedSongs = allSongs.sorted(by: {$0.skipCount > $1.skipCount})
            case "Recently Played Songs":
                self.requestedSongs = allSongs.sorted(by: {$0.lastPlayedDate ?? refDate() > $1.lastPlayedDate ?? refDate()})
            case "Recently Added Songs":
                self.requestedSongs = allSongs.sorted(by: {$0.dateAdded > $1.dateAdded})
            case "Longest Songs":
                self.requestedSongs = allSongs.sorted(by: {$0.playbackDuration > $1.playbackDuration})
            case "Oldest Songs":
                self.requestedSongs = allSongs.sorted(by: {$0.releaseDate ?? refDate() < $1.releaseDate ?? refDate()})
            default: break
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.analyticsLoading.stopAnimating()
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
        return requestedSongs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "analyticsDetail", for: indexPath)

        cell.imageView?.image = getArtworkIconWithDefaults(using: requestedSongs[indexPath.row])
        var title = ""
        DispatchQueue.global(qos: .userInteractive).async{ [weak self] in
            title = truncateTableViewText(with: self?.requestedSongs[indexPath.row].title ?? "")
            DispatchQueue.main.async {
                cell.textLabel?.text = title
            }
        }
        switch mode{
        case "Most Listened Songs", "Least Listened Songs":
            cell.detailTextLabel?.text = String(requestedSongs[indexPath.row].playCount) + " Plays"
        case "Most Skipped Songs":
            cell.detailTextLabel?.text = String(requestedSongs[indexPath.row].skipCount) + " Skips"
        case "Recently Played Songs":
            cell.detailTextLabel?.text = dateFormatter.string(from: requestedSongs[indexPath.row].lastPlayedDate ?? refDate())
        case "Recently Added Songs":
            cell.detailTextLabel?.text = dateFormatter.string(from: requestedSongs[indexPath.row].dateAdded)
        case "Longest Songs":
            cell.detailTextLabel?.text = timeIntervalToReg(requestedSongs[indexPath.row].playbackDuration)
        case "Oldest Songs":
            cell.detailTextLabel?.text =
                String(Calendar.current.component(.year , from: requestedSongs[indexPath.row].releaseDate ?? refDate()))
        default: break
        }

        return cell
    }

}
