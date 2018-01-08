//
//  AlbumCollectionViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/28/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

private let reuseIdentifier = "album"

class AlbumCollectionViewController: UICollectionViewController {
    var albums:[[MPMediaItem]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = "Albums"
        //append all songs into double a double array, with each sub-array being a whole album
        let allAlbums = MPMediaQuery.albums().items ?? []
        var prev: MPMediaItem! = allAlbums[0]
        var tempAlbum: [MPMediaItem] = []
        var count = 0
        for item in allAlbums{
            let currAlbumTitle = item.albumTitle ?? "NoAlbum"
            let prevAlbumTitle = prev.albumTitle ?? "No-Album"
            if count == 0 {
                tempAlbum.append(item)
                prev = item
                count += 1
                continue
            }
            if (prevAlbumTitle != currAlbumTitle){ // new album
                albums.append(tempAlbum)
                tempAlbum.removeAll()
            }
            tempAlbum.append(item)
            prev = item
            count += 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = 375.0 // UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width / 2.05, height: width / 1.71)// 2.05 & 1.75
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let albumCell = cell as? AlbumCollectionViewCell{
            albumCell.updateCell(with: albums[indexPath.row][0])
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let dest = destinationViewController as? AlbumTableViewController{
            if let indexPath = self.collectionView?.indexPathsForSelectedItems?.first!{
                dest.albumContents = albums[indexPath.row]
                dest.navigationItem.title = albums[indexPath.row][0].albumTitle ?? ""
            }
            
        }
    }

}
