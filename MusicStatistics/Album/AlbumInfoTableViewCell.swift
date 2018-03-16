//
//  AlbumInfoTableViewCell.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/30/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var infoAlbumTitle: UILabel!
    @IBOutlet weak var infoAlbumArtist: UILabel!
    @IBOutlet weak var miscInfo: UILabel!
    
    func updateAlbumInfo(with item:MPMediaItem){
        let windowSize = UIScreen.main.bounds.size
        infoAlbumTitle.text = item.albumTitle ?? ""
        infoAlbumArtist.text = item.albumArtist ?? ""
        let genre = item.genre ?? ""
        var year: String!
        if item.releaseDate != nil{
            year = " · " + String(Calendar.current.component(.year, from: item.releaseDate!))
        } else {
            year = ""
        }
        miscInfo.text = genre + year
        
        if item.artwork?.image != nil {
            albumImg.image = item.artwork?.image(at: CGSize(width: windowSize.width/1.2, height: windowSize.width/1.2))
        } else {
            albumImg.image = UIImage(named:"guitar")
        }
        albumImg.layer.borderColor = UIColor.lightGray.cgColor
        albumImg.layer.borderWidth = 0.5
    }

}
