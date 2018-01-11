//
//  Common.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/9/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import MediaPlayer

private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

func sortIntoSongSections(with allSongs:[MPMediaItem], and mode:String) -> ([[MPMediaItem]], [String]){
    var results: [[MPMediaItem]] = []
    var tempCollection: [MPMediaItem] = []
    var count = 0
    var secTitles:[String] = []
    var currentLetter: String!
    
    var prevLetter: String!
    switch mode{
        case "Title": prevLetter = findFirstLetter(with: allSongs.first?.title ?? " ")
        case "Artist": prevLetter = findFirstLetter(with: allSongs.first?.artist ?? " ")
        case "Album": prevLetter = findFirstLetter(with: allSongs.first?.albumTitle ?? " ")
        case "Genre": prevLetter = findFirstLetter(with: allSongs.first?.genre ?? " ")
        default: break
    }
    
    for item in allSongs{
        if count == 0{
            tempCollection.append(item)
            count += 1
            continue
        }
        switch mode{
            case "Title":
                currentLetter = findFirstLetter(with: item.title ?? " ")
                if String(item.title?.first ?? Character(" ")).isNumber { currentLetter = "#" }
            case "Artist":
                currentLetter = findFirstLetter(with: item.artist ?? " ")
                if String(item.artist?.first ?? Character(" ")).isNumber { currentLetter = "#" }
            case "Album":
                currentLetter = findFirstLetter(with: item.albumTitle ?? " ")
                if String(item.albumTitle?.first ?? Character(" ")).isNumber { currentLetter = "#" }
            case "Genre":
                currentLetter = findFirstLetter(with: item.genre ?? " ")
                if String(item.genre?.first ?? Character(" ")).isNumber { currentLetter = "#" }
            default: break
        }
        
        if prevLetter != currentLetter && prevLetter != "#"{
            results.append(tempCollection)
            tempCollection.removeAll()
            secTitles.append(prevLetter)
        }
        tempCollection.append(item)
        prevLetter = currentLetter
        count += 1
        if item == allSongs.last! {
            results.append(tempCollection)
            secTitles.append("#")
        }
    }
    return (results,secTitles)
}

private func findFirstLetter(with text:String) -> String{
    if text.starts(with: "The ") && text.count > 4 { return String(text[4])}
    if text.starts(with: "A ") && text.count > 2 {return String(text[2])}
    let strLetters = Array(text)
    for i in strLetters {if alphabet.contains(String(i).uppercased()) { return String(i).uppercased()} }
    return " "
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension UIImageView{
    func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

