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
    var analyticsDetails: [MPMediaItem]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return analyticsDetails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "analyticsDetail", for: indexPath)

        // Configure the cell...
        cell.imageView?.image = analyticsDetails[indexPath.row].artwork?.image(at: CGSize(width:30,height:30))
        cell.textLabel?.text = analyticsDetails[indexPath.row].title ?? ""
        cell.detailTextLabel?.text = String(analyticsDetails[indexPath.row].playCount) + " Plays"

        return cell
    }

}
