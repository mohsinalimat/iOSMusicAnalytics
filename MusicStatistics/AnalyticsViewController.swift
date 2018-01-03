//
//  AnalyticsViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/2/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AnalyticsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var allSongs: [MPMediaItem]!
    var MLSongs: [MPMediaItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allSongs = MPMediaQuery.songs().items ?? []
        //MLSongs = allSongs.sorted(by: {$0.playCount > $1.playCount})
        MLSongs = allSongs.sorted(by: {$0.playCount > $1.playCount})
    }
    
    @IBOutlet weak var MLSongsCollectionView: UICollectionView! {
        didSet{
            MLSongsCollectionView.delegate = self
            MLSongsCollectionView.dataSource = self
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30 // show 30 most played songs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MLSongs", for: indexPath)
        if let analyticsCell = cell as? AnalyticsCollectionViewCell{
            analyticsCell.updateAnalyticsCellUI(with: MLSongs[indexPath.row])
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
