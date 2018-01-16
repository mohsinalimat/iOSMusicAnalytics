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

//sort all albums into alphabetical sections
func sortAlbumsIntoSections(with allAlbums:[[MPMediaItem]]) -> ([[[MPMediaItem]]], [String]){
    var count = 0
    var secTitles:[String] = []
    var temp: [[MPMediaItem]] = []
    var results: [[[MPMediaItem]]] = []
    var currentLetter: String!
    var prevLetter: String! = findFirstLetter(with: allAlbums.first?.first?.albumTitle ?? " ")
    for item in allAlbums{
        if count == 0{
            temp.append(item)
            count += 1
            continue
        }
        currentLetter = findFirstLetter(with: item.first?.albumTitle ?? " ")
        if String(item.first?.albumTitle?.first ?? Character(" ")).isNumber { currentLetter = "#" }
        if prevLetter != currentLetter && prevLetter != "#"{
            results.append(temp)
            temp.removeAll()
            secTitles.append(prevLetter)
        }
        temp.append(item)
        prevLetter = currentLetter
        count += 1
        if item == allAlbums.last! {
            results.append(temp)
            secTitles.append("#")
        }
    }
    return (results,secTitles)
}

//append all songs into double a double array, with each sub-array being a whole album
func sortSongsIntoAlbums() -> [[MPMediaItem]]{
    var albums:[[MPMediaItem]] = []
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
        if item == allAlbums.last!{
            albums.append(tempAlbum)
        }
    }
    return albums
}

private func findFirstLetter(with text:String) -> String{
    if text.starts(with: "The ") && text.count > 4 { return String(text[4])}
    if text.starts(with: "A ") && text.count > 2 {return String(text[2])}
    let strLetters = Array(text)
    for i in strLetters {if alphabet.contains(String(i).uppercased()) { return String(i).uppercased()} }
    return " "
}

// returns the reference date
func refDate() -> Date {
    return Date(timeIntervalSinceReferenceDate: 0)
}

func analyticsCompareDate(with date1: Date, date2: Date) -> Bool{
    return Calendar.current.component(.month, from: date1) == Calendar.current.component(.month, from: date2)
    && Calendar.current.component(.day, from: date1) == Calendar.current.component(.day, from: date2)
}

func obtainAnalyticsData() -> ([String],[Int]){
    let descriptors = ["Songs Listened", "Minutes Listened"]
    var descriptorResults:[Int] = []
    var songsCount = 0
    var minutesCount:TimeInterval = 0.0
    let allSongs = MPMediaQuery.songs().items ?? []
    let requestedSongs = allSongs.sorted(by: {$0.lastPlayedDate ?? refDate() > $1.lastPlayedDate ?? refDate()})
    var count = 0
    var lastDate:Date!
    for item in requestedSongs{
        if count == 0 {
            lastDate = item.lastPlayedDate ?? refDate()
            songsCount += 1
            minutesCount += item.playbackDuration
            count += 1
            continue
        }
        //if (item.lastPlayedDate ?? refDate()) != lastDate { break }
        if (!analyticsCompareDate(with: item.lastPlayedDate ?? refDate(), date2: lastDate)) { break }
        lastDate = item.lastPlayedDate ?? refDate()
        songsCount += 1
        minutesCount += item.playbackDuration
    }
    
    descriptorResults = [songsCount,Int(minutesCount/60)]
    return (descriptors,descriptorResults)
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

