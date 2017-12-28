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
//        print(windowRect.size.width)
        let size = CGSize(width: windowRect.size.width, height: windowRect.size.width)
        albumCover.image = item.artwork?.image(at: size)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
