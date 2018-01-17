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
    let modeIcons: Dictionary<Int, UIImage> =
        [0: UIImage(named: "mostPlayedIcon")!,1: UIImage(named: "worried")!,2: UIImage(named: "fearfulIcon")!,
         3: UIImage(named: "recentsIcon")!, 4:UIImage(named: "addIcon")!]
    var sectionsTitles: [String] = ["Most Recent", "Interesting Stuff"]
    var dataDescriptors:[String] = Array()
    var dataDescriptorValues:[Int] = Array()
    var mostRecentSectionTitle = "N/A"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Analytics"
        (dataDescriptors,dataDescriptorValues,mostRecentSectionTitle) = obtainAnalyticsData()
        sectionsTitles[0] = mostRecentSectionTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 3 }
        return analyticsMode.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitles[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "analytics", for: indexPath)
//        if let analyticsCell = cell as? AnalyticsTableViewCell{
//            analyticsCell.updateAnalyticsCell(with: analyticsMode[indexPath.row]!)
//        }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "analyticsData", for: indexPath)
            cell.layer.cornerRadius = 20.0
            cell.layer.borderWidth = 8.0
            if let dataCell = cell as? AnalyticsDataTableViewCell{
                dataCell.updateData(with: dataDescriptors[indexPath.row], and: String(dataDescriptorValues[indexPath.row]))
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleAnalyticsCell", for: indexPath)
        cell.textLabel?.text = analyticsMode[indexPath.row]! + " Songs"
        cell.imageView?.image = modeIcons[indexPath.row]
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.size.height / 3.5
        if indexPath.section == 0 { return 90.0 }
        return 50.0
    }
    
    @IBAction func refreshAnalytics(_ sender: UIRefreshControl) {
        (dataDescriptors,dataDescriptorValues,mostRecentSectionTitle) = obtainAnalyticsData()
        sectionsTitles[0] = mostRecentSectionTitle
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let dest = destinationViewController as? AnalyticsDetailTableViewController{
            if let tappedIndex = tableView.indexPathForSelectedRow{
//                let containedCell = tableView.cellForRow(at: tappedIndex) as? AnalyticsTableViewCell
//                dest.analyticsDetails = containedCell?.requestedSongs
                dest.navigationItem.title = tableView.cellForRow(at: tappedIndex)?.textLabel?.text
                dest.mode = analyticsMode[tappedIndex.row]
            }
//            else {
//                dest.analyticsDetails = []
//            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
        headerView.contentView.backgroundColor = UIColor.lightText
        return headerView
    }
    
}
