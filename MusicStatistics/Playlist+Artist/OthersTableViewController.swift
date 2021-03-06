//
//  PlaylistTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/28/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class OthersTableViewController: UITableViewController {
    var allItems: [[[MPMediaItem]]] = []
    var sectionTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.black
        let activityIndicator = CustomSpinner(with: view, andFrame: view.bounds)
        activityIndicator.startSpinning()
        var artists: [[MPMediaItem]]! = []
        DispatchQueue.global(qos: .userInitiated).async{
            let allArtists = MPMediaQuery.artists()
            allArtists.groupingType = .albumArtist
            let collections = allArtists.collections
            for playlist in collections!{
                artists.append(playlist.items)
            }
            (self.allItems,self.sectionTitles) = sortAlbumsOrArtistsIntoSections(with: artists, andMode: "Artists")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.separatorColor = UIColor.white
                activityIndicator.endSpinning()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)

        cell.imageView?.image = getArtworkIconWithDefaults(using: allItems[indexPath.section][indexPath.row].first!)
        cell.imageView?.layer.cornerRadius = 30.0
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = allItems[indexPath.section][indexPath.row].first?.albumArtist
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let count = self?.allItems[indexPath.section][indexPath.row].count ?? 0
            var countStr = "\(count) song"
            if count != 1 { countStr += "s"}
            var playcount = 0
            for song in (self?.allItems[indexPath.section][indexPath.row] ?? []) {
                playcount += song.playCount
            }
            DispatchQueue.main.async {
                cell.detailTextLabel?.text = countStr + " · " + String(playcount) + " plays"
            }
        }

        return cell
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
        if let dest = destinationViewController as? AlbumCollectionViewController{
            dest.isNativeAlbumController = false
            dest.contents = allItems[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row]
            dest.navigationItem.title = allItems[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row].first?.albumArtist
        }
    }
}
