//
//  AnalyticsTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/3/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class AnalyticsTableViewController: UITableViewController {
    let analyticsMode: Dictionary<Int,String> = [0:"Most Listened", 1:"Least Listened", 2:"Most Skipped", 3: "Least Skipped"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Analytics"

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
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "analytics", for: indexPath)

        if let analyticsCell = cell as? AnalyticsTableViewCell{
            //analyticsCell.analyticsModeLabel = analyticsMode[indexPath.row]
            analyticsCell.updateAnalyticsCell(with: analyticsMode[indexPath.row]!)
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.traitCollection.verticalSizeClass == .compact{
            return UIScreen.main.bounds.size.height / 2
        }
        return UIScreen.main.bounds.size.height / 3.5
        //return UITableViewAutomaticDimension
    }

}
