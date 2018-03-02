//
//  AnalyticsTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/3/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreData

class AnalyticsTableViewController: UITableViewController {
    let analyticsMode: Dictionary<Int,String> =
        [0:"Most Listened Songs", 1:"Least Listened Songs", 2:"Most Skipped Songs",3 : "Recently Played Songs", 4: "Recently Added Songs",5:"Longest Songs",
         6: "Oldest Songs"]
    let modeIcons: Dictionary<Int, UIImage> =
        [0: UIImage(named: "mostPlayedIcon")!,1: UIImage(named: "worried")!,2: UIImage(named: "fearfulIcon")!,
         3: UIImage(named: "recentsIcon")!, 4:UIImage(named: "addIcon")!,5:UIImage(named: "lengthIcon")!, 6:UIImage(named: "ageIcon")!]
    var sectionsTitles: [String] = ["Most Recent", "Interesting Stuff"]
    var dataDescriptors:[String] = Array()
    var dataDescriptorValues:[Int] = Array()
    let dataSpecificsDescriptors = ["Most Listened Artist", "Most Listened Genre"]
    var dataSpecifics:[String] = []
    var mostRecentSectionTitle = "N/A"
    var container : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    func loadAnalyticsData(){
        (dataDescriptors,dataDescriptorValues,dataSpecifics,mostRecentSectionTitle) = obtainAnalyticsData()
        sectionsTitles[0] = mostRecentSectionTitle
    }
    
    func updateAnalyticsDatabase(){
        if (getLastLaunchDate() == nil || getLastLaunchDate() != getStringFromDate(with: Date())){ // add new entry
            AnalyticsDate.addNewEntry(with: dataDescriptorValues, in: container!.viewContext)
            storeLastLaunchDate()
        } else { // edit entry
            AnalyticsDate.editAnalyticsData(using:
                (getStringFromDate(with: Date()),dataDescriptorValues), in: container!.viewContext)
        }
        try? container?.viewContext.save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Analytics"
        //self.navigationController?.hidesBarsOnSwipe = true
        loadAnalyticsData()
        updateAnalyticsDatabase()
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
        if section == 0 { return 6 }
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
        if indexPath.section == 0 && indexPath.row < 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "analyticsData", for: indexPath)
            cell.layer.cornerRadius = 20.0
            cell.layer.borderWidth = 8.0
            if let dataCell = cell as? AnalyticsDataTableViewCell{
                dataCell.updateData(with: dataDescriptors[indexPath.row], and: String(dataDescriptorValues[indexPath.row]))
            }
            return cell
        } else if indexPath.section == 0 && indexPath.row >= 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "analyticsDataSpecific", for: indexPath)
            cell.layer.cornerRadius = 20.0
            cell.layer.borderWidth = 8.0
            if let dataCell = cell as? AnalyticsDataTableViewCell{
                dataCell.updateData(with: dataSpecificsDescriptors[indexPath.row-4], and:
                    String(dataSpecifics[indexPath.row - 4]))
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleAnalyticsCell", for: indexPath)
        cell.textLabel?.text = analyticsMode[indexPath.row]!
        cell.imageView?.image = modeIcons[indexPath.row]
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.size.height / 3.5
        if indexPath.section == 0 { return 90.0 }
        return 50.0
    }
    
    @IBAction func refreshAnalytics(_ sender: UIRefreshControl) {
        DispatchQueue.main.async { [weak self] in
            self?.loadAnalyticsData()
            self?.tableView.reloadData()
            self?.updateAnalyticsDatabase()
            self?.refreshControl?.endRefreshing()
        }
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
        if let dest = destinationViewController as? AnalyticsGraphViewController{
            let data = AnalyticsDate.retrieveAnalyticsData(in: container!.viewContext)
            var tempX = [String]()
            var tempY = [Int]()
            for (date, numbers) in data{
                tempX.append(date)
                let tappedIndex = tableView.indexPathForSelectedRow!.row
                tempY.append(numbers[tappedIndex])
            }
            dest.xData = tempX
            dest.yData = tempY
            let mode = (tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! AnalyticsDataTableViewCell).descriptor.text ?? "Analytics"
            dest.mode = mode
            dest.navigationItem.title = mode
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
        headerView.contentView.backgroundColor = UIColor.lightText
        return headerView
    }
    
}
