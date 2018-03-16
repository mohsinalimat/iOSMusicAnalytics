//
//  LyricsViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreData

class LyricsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var lyricsTextField: UITextView!
    var isViewing: Bool!
    var existingLyrics: String = "None"
    var searchItem: String!
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lyricsTextField.keyboardAppearance = .dark
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Do any additional setup after loading the view.
        if (existingLyrics != "None"){
            lyricsTextField.text = existingLyrics
            lyricsTextField.isEditable = false
        } else if isViewing{
            lyricsTextField.text = Song.getLyrics(using: searchItem, in: container!.viewContext)
        }
    }

    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        //save data when no lyrics are already present in mediaItem
        if existingLyrics == "None"{
            if !isViewing{ // adding lyrics to DB
                Song.addLyricsToSong(to: searchItem, using: lyricsTextField.text!, in: container!.viewContext)
            } else { // save lyric edits
                Song.editLyrics(using: searchItem, and: lyricsTextField.text!, in: container!.viewContext)
            }
            if !lyricsTextField.text.isEmpty { try? container?.viewContext.save() }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
