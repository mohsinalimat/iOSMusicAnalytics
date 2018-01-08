//
//  AnalyticsTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/3/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class AnalyticsTableViewController: UITableViewController {
    let analyticsMode: Dictionary<Int,String> =
        [0:"Most Listened", 1:"Least Listened", 2:"Most Skipped",3 : "Recently Played", 4: "Recently Added"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Analytics"
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
        return analyticsMode.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "analytics", for: indexPath)

        if let analyticsCell = cell as? AnalyticsTableViewCell{
            analyticsCell.updateAnalyticsCell(with: analyticsMode[indexPath.row]!)
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.size.height / 3.5
        return 191.0
    }
    
    @IBAction func refreshAnalytics(_ sender: UIRefreshControl) {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let dest = destinationViewController as? AnalyticsDetailTableViewController{
            //print(tableView.indexPathForSelectedRow?.row)
            if let tappedIndex = tableView.indexPathForSelectedRow{
                let containedCell = tableView.cellForRow(at: tappedIndex) as? AnalyticsTableViewCell
                dest.analyticsDetails = containedCell?.requestedSongs
            } else {
                dest.analyticsDetails = []
            }
//            if let containedCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!){
//                let converted = containedCell as? AnalyticsTableViewCell
//
//            }
        }
    }
    
}
