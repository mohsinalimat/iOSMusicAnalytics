//
//  SortSongsViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/29/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

// behavior: if no cell is selected, return the sorting the mode to be the same as the initial one
import UIKit

class SortSongsViewController: UITableViewController {
    var currentSortingMode: String!
    var memSortingMode: String! // memory
    let indexToMode:Dictionary<Int, String> = [0 : "Title", 1: "Artist", 2: "Album", 3: "Genre"]
    var feedbackGenerator:UISelectionFeedbackGenerator?
    var alreadySelectedIndex = 0
    var deselectedFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memSortingMode = currentSortingMode
        feedbackGenerator = UISelectionFeedbackGenerator()
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.cellForRow(at: IndexPath(row: alreadySelectedIndex, section: 0))?.accessoryView?.tintColor = myOrange()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortSongsCell", for: indexPath)
        cell.textLabel?.text = indexToMode[indexPath.row]
        if indexToMode[indexPath.row] == currentSortingMode{
            cell.accessoryType = .checkmark
            cell.accessoryView?.tintColor = myOrange()
            alreadySelectedIndex = indexPath.row
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deselectedFirst && indexPath.row != alreadySelectedIndex{
            tableView.cellForRow(at: IndexPath(row: alreadySelectedIndex, section: 0))?.accessoryType = .none
            deselectedFirst = false
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.tintColor = myOrange()
        feedbackGenerator?.selectionChanged()
        currentSortingMode = indexToMode[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        feedbackGenerator?.selectionChanged()
        currentSortingMode = memSortingMode
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelSorting(_ sender: UIBarButtonItem) {
       dismiss(animated: true)
    }
    

}
