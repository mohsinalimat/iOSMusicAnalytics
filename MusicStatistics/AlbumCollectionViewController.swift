//
//  AlbumCollectionViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 12/28/17.
//  Copyright © 2017 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer
import BDKCollectionIndexView

private let reuseIdentifier = "album"

class AlbumCollectionViewController: UICollectionViewController {
    var albums:[[[MPMediaItem]]] = []
    var sectionTitles: [String] = []
    var haptic = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Albums"
        (albums,sectionTitles) = sortAlbumsIntoSections(with: sortSongsIntoAlbums())
        
        let indexWidth:CGFloat = 14.0
        let frameWidth = collectionView?.frame.width
        let frameHeight = collectionView?.frame.height
        let frame = CGRect(x: frameWidth! - 14, y: 0, width: indexWidth, height: frameHeight!)
        let indexView = BDKCollectionIndexView(frame: frame, indexTitles: nil)
        indexView!.indexTitles = sectionTitles
        indexView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indexView!.tintColor = UIColor.orange
        indexView!.addTarget(self, action: #selector(self.indexViewValueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(indexView!)
        self.view.bringSubview(toFront: indexView!)
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
    
    @objc func indexViewValueChanged(sender: BDKCollectionIndexView){
        haptic.impactOccurred()
        let indexPath = IndexPath(item: 0, section: Int(sender.currentIndex))
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: false)
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
            albumCell.updateCell(with: albums[indexPath.section][indexPath.row].last!)
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
        if let dest = destinationViewController as? SearchAlbumTableViewController{
            dest.unfilteredAlbums = sortSongsIntoAlbums()
            dest.navigationItem.title = "Search Albums"
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
   
    /*
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
     */

}
