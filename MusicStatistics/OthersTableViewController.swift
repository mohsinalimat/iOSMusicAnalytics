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
        var playlists: [[MPMediaItem]]! = []
        
        let allPlaylists = MPMediaQuery.artists()
        allPlaylists.groupingType = .albumArtist
        let collections = allPlaylists.collections
        for playlist in collections!{
            playlists.append(playlist.items)
        }
        (allItems,sectionTitles) = sortAlbumsOrArtistsIntoSections(with: playlists, andMode: "Artists")
    }
    
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.title = "Artists"
            self.tabBarItem.image = UIImage(named: "artistIcon")
        case 1:
            self.title = "Playlists"
            self.tabBarItem.image = UIImage(named: "playlistBarIcon")
        default: break
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

        cell.imageView?.image = allItems[indexPath.section][indexPath.row].first?.artwork?.image(at: CGSize(width: 60, height:60))
        cell.imageView?.layer.cornerRadius = 30.0
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = allItems[indexPath.section][indexPath.row].first?.albumArtist
        cell.detailTextLabel?.text = "\(allItems[indexPath.section][indexPath.row].count) song(s)"

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
            dest.contents = allItems[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row].sorted(by: {$0.albumTitle ?? "Unknown" < $1.albumTitle ?? "Unknown"})
            dest.navigationItem.title = allItems[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row].first?.albumArtist
            print(dest.contents.isEmpty)
        }
    }
}
