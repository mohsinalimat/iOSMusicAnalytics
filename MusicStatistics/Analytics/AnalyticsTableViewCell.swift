//
//  AnalyticsTableViewCell.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/3/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AnalyticsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var mode: UILabel!
    var allSongs: [MPMediaItem]!
    var requestedSongs: [MPMediaItem]!
    var subMode: String!
    
    func updateAnalyticsCell(with operateMode:String){
        mode.text = operateMode +  " Songs"
        allSongs = MPMediaQuery.songs().items ?? []
        switch operateMode{
        case "Most Listened":
            requestedSongs = allSongs.sorted(by: {$0.playCount > $1.playCount})
            subMode = "Playcount"
        case "Least Listened":
            requestedSongs = allSongs.sorted(by: {$0.playCount < $1.playCount})
            subMode = "Playcount"
        case "Most Skipped":
            requestedSongs = allSongs.sorted(by: {$0.skipCount > $1.skipCount})
            subMode = "Skipcount"
        case "Recently Played":
            requestedSongs = allSongs.sorted(by: {$0.lastPlayedDate ?? refDate() > $1.lastPlayedDate ?? refDate()})
            subMode = "LPDate"
        case "Recently Added":
            requestedSongs = allSongs.sorted(by: {$0.dateAdded > $1.dateAdded})
            subMode = "LADate"
        default: break
        }
    }
    
    @IBOutlet weak var analyticsCL: UICollectionView!{
        didSet{
            analyticsCL.delegate = self
            analyticsCL.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestedSongs.count >= 15 ? 15 : requestedSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "analyticsCollec", for: indexPath)
        if let subCell = cell as? AnalyticsCollectionViewCell{
            subCell.updateAnalyticsCellUI(with: requestedSongs[indexPath.row], mode: subMode)
        }
        
        return cell
    }
    
}
