//
//  SearchAlbumTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/19/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class SearchAlbumTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var unfilteredAlbums:[[MPMediaItem]] = []
    var filteredAlbums:[[MPMediaItem]] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        filteredAlbums = unfilteredAlbums
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.placeholder = "Search for Songs"
        searchController.searchBar.keyboardAppearance = .dark
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.orange
        tableView.tableHeaderView = searchController.searchBar
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
        return filteredAlbums.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSearchResults", for: indexPath)

        // Configure the cell...
        let alb = filteredAlbums[indexPath.row][0]
        if alb.artwork != nil {
            cell.imageView?.image = alb.artwork?.image(at: CGSize(width: 40, height: 40))
        } else {
            cell.imageView?.image = UIImage(named: "guitarIcon")
        }
        cell.textLabel?.text = alb.albumTitle ?? "Unknown"
        cell.detailTextLabel?.text = alb.artist ?? "Unknown"
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
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, !unfilteredAlbums.isEmpty{
            filteredAlbums = unfilteredAlbums.filter({($0.first!.albumTitle?.contains(searchText))!})
            if filteredAlbums.isEmpty {filteredAlbums = unfilteredAlbums}
        }
        tableView.reloadData()
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
        if let dest = destinationViewController as? AlbumTableViewController{
            dest.albumContents = filteredAlbums[tableView.indexPathForSelectedRow!.row]
            dest.navigationItem.title =
                filteredAlbums[tableView.indexPathForSelectedRow!.row].first!.albumTitle ?? "Unknown"
        }
    }
 

}
