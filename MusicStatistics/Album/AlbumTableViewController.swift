//
//  AlbumTableViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/30/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumTableViewController: UITableViewController {
    var albumContents: [MPMediaItem]!
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
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
        return albumContents.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumInfo", for: indexPath)
            if let infoCell = cell as? AlbumInfoTableViewCell{
                infoCell.updateAlbumInfo(with: albumContents.last!)
            }
            return cell
        }
        if indexPath.row == albumContents.count + 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "songPerAlbum", for: indexPath)
            var duration = 0
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                for item in self?.albumContents ?? []{
                    duration += Int(item.playbackDuration)
                }
                DispatchQueue.main.async {
                    let songCount = String(self?.albumContents.count ?? 0) + (self?.albumContents.count == 1 ? " Song · " : " Songs · ")
                    cell.textLabel?.text = songCount + String(duration/60) + " Minutes"
                    cell.detailTextLabel?.text = nil
                }
            }
            return cell
        }

        // Configure the cell...
        var trackNumber = ""; var spacing = ""; var trackTitle = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "songPerAlbum", for: indexPath)
        
        DispatchQueue.global(qos: .userInteractive).async{
            trackNumber = String(self.albumContents[indexPath.row - 1].albumTrackNumber)
            let originalTitle = self.albumContents[indexPath.row - 1].title ?? ""
            trackTitle = truncateTableViewText(with: originalTitle) // makes sure right detail is visible
            spacing = trackNumber.count == 1 ? "        " : "       "
            DispatchQueue.main.async {
                cell.textLabel?.text = trackNumber + spacing + trackTitle
            }
        }
        let duration = timeIntervalToReg(albumContents[indexPath.row - 1].playbackDuration)
        cell.detailTextLabel?.text = String(duration)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { //for the album info cell
            return UITableViewAutomaticDimension//UIScreen.main.bounds.size.width
        }
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            appDelegate.currentQueue = Array(albumContents[indexPath.row - 1..<albumContents.count])
            if let tabbar = appDelegate.window!.rootViewController as? UITabBarController{
                tabbar.selectedIndex = 2
            }
        }
    }
    @IBAction func presentAlbumActions(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = myOrange()
        
        let playAlbumAction = UIAlertAction(title: "Play", style: .default){ _ in
            self.appDelegate.currentQueue = self.albumContents
            if let tabbar = self.appDelegate.window!.rootViewController as? UITabBarController{
                tabbar.selectedIndex = 2
            }
        }
        
        let addQueueAction = UIAlertAction(title: "Add to Queue", style: .default){ _ in
            self.appDelegate.currentQueue.append(contentsOf: self.albumContents)
            overlayTextWithVisualEffect(using: "Done", on: self.view)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addQueueAction)
        alertController.addAction(playAlbumAction)
        present(alertController,animated: true)
    }
}
