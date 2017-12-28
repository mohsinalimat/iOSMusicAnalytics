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
    var albums:[MPMediaItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        albums = MPMediaQuery.albums().items!
        self.title = "Albums"
        // Do any additional setup after loading the view.
        
//        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
//            let width = UIScreen.main.bounds.width
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            layout.itemSize = CGSize(width: width / 2.1, height: width / 2.1)
//            layout.minimumInteritemSpacing = 0
//            layout.minimumLineSpacing = 0
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(albums.count)
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let albumCell = cell as? AlbumCollectionViewCell{
            albumCell.updateCell(with: albums[indexPath.row])
        }
        return cell
    }

}
