//
//  AnalyticsCollectionViewCell.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/2/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AnalyticsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var AnalyticsAlbumImg: UIImageView!
    @IBOutlet weak var analyticsSongTitle: UILabel!
    @IBOutlet weak var playCount: UILabel!
    
     let dateFormatter = DateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
         dateFormatter.dateFormat = "MMM dd"
    }
    
    // returns the reference date
    func refDate() -> Date {
        return Date(timeIntervalSinceReferenceDate: 0)
    }
    
    
    func updateAnalyticsCellUI(with item:MPMediaItem, mode subtitleMode:String){
        let width = UIScreen.main.bounds.size.width
        AnalyticsAlbumImg.image = item.artwork?.image(at: CGSize(width: width/3, height: width/3))
        analyticsSongTitle.text = item.title ?? ""
        if subtitleMode == "Skipcount"{
            playCount.text = subtitleMode + ": " + String(item.skipCount)
        } else if subtitleMode == "Playcount"{
            playCount.text = subtitleMode + ": " + String(item.playCount)
        } else if subtitleMode == "LADate"{
            playCount.text  = dateFormatter.string(from: item.dateAdded)
        } else if subtitleMode == "LPDate"{
            playCount.text  = dateFormatter.string(from: item.lastPlayedDate ?? refDate())
        }
        
    }
    
}
