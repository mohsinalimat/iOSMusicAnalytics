//
//  AlbumCollectionViewCell.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/28/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellAlbumCover: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellArtist: UILabel!
    
    func updateCell(with input:MPMediaItem){
        cellAlbumCover.image = input.artwork?.image(at: CGSize(width: 162, height: 162))
        cellTitle.text = input.albumTitle
        cellArtist.text = input.artist
    }
}
