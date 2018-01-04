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
    
    func updateAnalyticsCellUI(with item:MPMediaItem, mode subtitleMode:String){
        let width = UIScreen.main.bounds.size.width
        AnalyticsAlbumImg.image = item.artwork?.image(at: CGSize(width: width/3, height: width/3))
        analyticsSongTitle.text = item.title ?? ""
        if subtitleMode == "Skipcount"{
            playCount.text = subtitleMode + ": " + String(item.skipCount)
        } else if subtitleMode == "Playcount"{
            playCount.text = subtitleMode + ": " + String(item.playCount)
        }
        
    }
    
}
