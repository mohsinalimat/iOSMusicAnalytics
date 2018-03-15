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
    var isNativeAlbumController = true
    var contents:[MPMediaItem]! = []
    var indexView: BDKCollectionIndexView!
    @IBOutlet weak var albumAnalyticsButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Albums"
        (albums,sectionTitles) = ([],["N"])
        activityIndicator.startAnimating()
    }
    
    func loadIndexView(with sectionTitles: [String]){
        if indexView != nil {indexView.removeFromSuperview()}
        let indexWidth:CGFloat = 14.0
        let frameWidth = collectionView?.frame.width
        let frameHeight = collectionView?.frame.height
        let frame = CGRect(x: frameWidth! - 14, y: 0, width: indexWidth, height: frameHeight!)
        indexView = BDKCollectionIndexView(frame: frame, indexTitles: nil)
        indexView!.indexTitles = sectionTitles
        indexView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indexView!.tintColor = UIColor.orange
        indexView!.addTarget(self, action: #selector(self.indexViewValueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(indexView!)
        self.view.bringSubview(toFront: indexView!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAlbumCollectionViewLayout(with: collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (isNativeAlbumController){
            DispatchQueue.global(qos: .userInitiated).async {
                (self.albums,self.sectionTitles) = sortAlbumsOrArtistsIntoSections(with: sortSongsIntoAlbumsSimpleApproach(),andMode: "Albums")
                DispatchQueue.main.async {
                    self.loadIndexView(with: self.sectionTitles)
                    self.navigationItem.rightBarButtonItems?.last?.isEnabled = false
                    self.collectionView?.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.albums = [sortSongIntoAlbums(with: self.contents)]
                self.sectionTitles = ["All"]
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
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
                if isNativeAlbumController{
                    dest.albumContents = albums[indexPath.section][indexPath.row]
                } else {
                    dest.albumContents = albums[indexPath.section][indexPath.row]
                        .sorted(by: {$0.albumTrackNumber < $1.albumTrackNumber})
                }
                dest.navigationItem.title = albums[indexPath.section][indexPath.row][0].albumTitle ?? ""
            }
        }
        if let dest = destinationViewController as? SearchAlbumTableViewController{
            dest.unfilteredAlbums = sortSongsIntoAlbumsSimpleApproach()
            dest.navigationItem.title = "Search Albums"
        }
        if let dest = destinationViewController as? AnalyticsDetailTableViewController{
            dest.requestedSongs = contents
            dest.mode = "Most Listened Songs"
            dest.navigationItem.title = self.navigationItem.title ?? "Artist"
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
}
