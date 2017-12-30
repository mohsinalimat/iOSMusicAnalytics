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
    let modeToIndex:Dictionary<String,Int> = ["Title": 0 , "Artist": 1, "Album": 2, "Genre": 3]
    let indexToMode:Dictionary<Int, String> = [0 : "Title", 1: "Artist", 2: "Album", 3: "Genre"]
    var feedbackGenerator:UISelectionFeedbackGenerator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memSortingMode = currentSortingMode
        
        // programmatically add checkmark upon entering the modal mvc
        let indexPath = IndexPath(row: modeToIndex[currentSortingMode]!, section: 0)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        feedbackGenerator = UISelectionFeedbackGenerator()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
