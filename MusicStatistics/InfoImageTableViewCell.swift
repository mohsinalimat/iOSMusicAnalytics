//
//  InfoImageTableViewCell.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/28/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class InfoImageTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    var artwork : MPMediaItem!
    
    func updateAlbumArt(with item:MPMediaItem){
        let windowRect:CGRect = UIScreen.main.bounds
        let size = CGSize(width: windowRect.size.width, height: windowRect.size.width)
        if item.artwork?.image != nil {
            albumCover.image = item.artwork?.image(at: size)
        } else {
            albumCover.image = UIImage(named: "guitar")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
