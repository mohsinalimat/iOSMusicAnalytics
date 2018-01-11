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
    //var albums:[[MPMediaItem]] = []
    var albums:[[[MPMediaItem]]] = []
    var sectionTitles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Albums"
        (albums,sectionTitles) = sortAlbumsIntoSections(with: sortSongsIntoAlbums())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = 375.0 // UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width / 2.05, height: width / 1.71)// 2.05 & 1.75
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 27)
        collectionView!.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let albumCell = cell as? AlbumCollectionViewCell{
            albumCell.updateCell(with: albums[indexPath.section][indexPath.row].first!)
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
                dest.albumContents = albums[indexPath.section][indexPath.row]
                dest.navigationItem.title = albums[indexPath.section][indexPath.row][0].albumTitle ?? ""
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind{
//        case UICollectionElementKindSectionHeader:
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumHeaderView", for: indexPath) as? AlbumHeaderCollectionReusableView
        headerView?.albumHeaderLabel.text = sectionTitles[indexPath.section]
        return headerView!
//        default: break
//        }
    }
    
    override func indexTitles(for collectionView: UICollectionView) -> [String]? {
        super.indexTitles(for: collectionView)
        print("called indextitles")
        return sectionTitles
    }
    
    override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        super.collectionView(collectionView, indexPathForIndexTitle: title, at: index)
        print("called indexPathForIndexTitle")
        return IndexPath(row: 0, section: index)
    }

}
