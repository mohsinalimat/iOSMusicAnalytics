//
//  Common.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/9/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import MediaPlayer
import BDKCollectionIndexView
import Charts

private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
private let dateFormatter = DateFormatter()
private var mostListenedArtist:Dictionary<String, Int> = [:]
private var mostListenedGenre: Dictionary<String, Int> = [:]

func myOrange() -> UIColor { return UIColor(red: 1, green: 132/255, blue: 23/255, alpha: 1) }

func addArtistForRecent(with item:MPMediaItem){
    let artistName = item.artist ?? "Unknown"
    if mostListenedArtist[artistName] == nil {
        mostListenedArtist[artistName] = 0
    } else {
        mostListenedArtist[artistName] = mostListenedArtist[artistName ]! + 1
    }
}

func addGenreForRecent(with item:MPMediaItem){
    let genreName = item.genre ?? "Unknown"
    if mostListenedGenre[genreName] == nil {
        mostListenedGenre[genreName] = 0
    } else {
        mostListenedGenre[genreName] = mostListenedGenre[genreName]! + 1
    }
}

func sortIntoSongSections(with allSongs:[MPMediaItem], and mode:String) -> ([[MPMediaItem]], [String]){
    var results: [[MPMediaItem]] = []
    var tempCollection: [MPMediaItem] = []
    var count = 0
    var secTitles:[String] = []
    var currentLetter: String!
    dateFormatter.dateFormat = "MMM dd"
    
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
func sortAlbumsOrArtistsIntoSections(with allItems:[[MPMediaItem]], andMode mode:String) -> ([[[MPMediaItem]]], [String]){
    var count = 0
    var secTitles:[String] = []
    var temp: [[MPMediaItem]] = []
    var results: [[[MPMediaItem]]] = []
    var currentLetter: String!
    var prevLetter: String!
    switch mode {
    case "Artists":
        prevLetter = findFirstLetter(with: allItems.first?.first?.albumArtist ?? " ")
    case "Albums":
        prevLetter = findFirstLetter(with: allItems.first?.first?.albumTitle ?? " ")
    default: break
    }
    for item in allItems{
        if count == 0{
            temp.append(item)
            count += 1
            continue
        }
        switch mode{
        case "Artists":
            currentLetter = findFirstLetter(with: item.first?.albumArtist ?? " ")
            if String(item.first?.albumArtist?.first ?? Character(" ")).isNumber { currentLetter = "#" }
        case "Albums":
            currentLetter = findFirstLetter(with: item.first?.albumTitle ?? " ")
            if String(item.first?.albumTitle?.first ?? Character(" ")).isNumber { currentLetter = "#" }
        default: break
        }
        if prevLetter != currentLetter && prevLetter != "#"{
            results.append(temp)
            temp.removeAll()
            secTitles.append(prevLetter)
        }
        temp.append(item)
        prevLetter = currentLetter
        count += 1
        if item == allItems.last! {
            results.append(temp)
            secTitles.append("#")
        }
    }
    return (results,secTitles)
}

//append all songs into double a double array, with each sub-array being a whole album
func sortSongsIntoAlbumsSimpleApproach() -> [[MPMediaItem]]{
    var albums:[[MPMediaItem]] = []
    let allAlbums = MPMediaQuery.albums().collections
    if allAlbums != nil{
        for album in allAlbums!{
            albums.append(album.items)
        }
    }
    return albums
}

func sortSongIntoAlbums(with songs:[MPMediaItem])  -> [[MPMediaItem]]{
    var albums:[[MPMediaItem]] = []
    let allSongs = songs
    var prev: MPMediaItem! = allSongs[0]
    var tempAlbum: [MPMediaItem] = []
    var count = 0
    for song in allSongs{
        let currAlbumTitle = song.albumTitle ?? "NoAlbum"
        let prevAlbumTitle = prev.albumTitle ?? "No-Album"
        if count == 0 {
            tempAlbum.append(song)
            prev = song
            count += 1
            if song == allSongs.last!{
                albums.append(tempAlbum)
            }
            continue
        }
        if (prevAlbumTitle != currAlbumTitle){ // new album
            albums.append(tempAlbum)
            tempAlbum.removeAll()
        }
        tempAlbum.append(song)
        prev = song
        if song == allSongs.last!{
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


//returns -> descriptors,numeric data, specific text data,  mostRecentSectionTitle
func obtainAnalyticsData() -> ([String],[Int], [String] , String){
    let descriptors = ["Songs Listened", "Minutes Listened", "Different Albums Listened", "Different Artists Listened"]
    var mostRecentSectionTitle = "N/A"
    mostListenedArtist.removeAll()
    mostListenedGenre.removeAll()
    var descriptorResults:[Int] = []
    var songsCount = 0
    var albumsSet: Set<String> = []
    var artistSet: Set<String> = []
    var minutesCount:TimeInterval = 0.0
    let requestedSongs =
        (MPMediaQuery.songs().items ?? []).sorted(by: {$0.lastPlayedDate ?? refDate() > $1.lastPlayedDate ?? refDate()})
    var lastDate:Date!
    for item in requestedSongs{
        if item == requestedSongs.first! {
            lastDate = item.lastPlayedDate ?? refDate()
            mostRecentSectionTitle = dateFormatter.string(from: lastDate)
            songsCount += 1
            minutesCount += item.playbackDuration
            albumsSet.insert(item.albumTitle ?? "Unknown")
            artistSet.insert(item.artist ?? "Unknown")
            addArtistForRecent(with: item)
            addGenreForRecent(with: item)
            continue
        }
        if (!analyticsCompareDate(with: item.lastPlayedDate ?? refDate(), date2: lastDate)) { break }
        lastDate = item.lastPlayedDate ?? refDate()
        songsCount += 1
        minutesCount += item.playbackDuration
        albumsSet.insert(item.albumTitle ?? "Unknown")
        artistSet.insert(item.artist ?? "Unknown")
        addArtistForRecent(with: item)
        addGenreForRecent(with: item)
    }
    var specificData: [String] = []
    
    let artistSorted = mostListenedArtist.sorted(by: {$0.value > $1.value})
    if artistSorted.isEmpty {specificData.append("N/A")}
    else if artistSorted.first!.value == 1  {specificData.append("N/A")}
    else {specificData.append(artistSorted.first!.key)}
    
    let genreSorted = mostListenedGenre.sorted(by: {$0.value > $1.value})
    if genreSorted.isEmpty {specificData.append("N/A")}
    else if genreSorted.first!.value == 1  {specificData.append("N/A")}
    else {specificData.append(genreSorted.first!.key)}

    descriptorResults = [songsCount,Int(minutesCount/60),albumsSet.count, artistSet.count]
    return (descriptors,descriptorResults,specificData, mostRecentSectionTitle)
}

func setupAlbumCollectionViewLayout(with collectionView: UICollectionView?){
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let width = 375.0 // UIScreen.main.bounds.width
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: width / 2.05, height: width / 1.71)// 2.05 & 1.75
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 27)
    collectionView!.collectionViewLayout = layout
}


func timeIntervalToReg(_ interval:TimeInterval) -> String{
    let minute = String(Int(interval) / 60)
    var seconds = String(Int(interval) % 60)
    if seconds.count == 1 {seconds = "0" + seconds}
    return minute + ":" + seconds
}


func overlayTextWithVisualEffect(using text:String, on view: UIView){
    let blurEffect = UIBlurEffect(style: .prominent)
    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
    let effectBounds = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 66),size: CGSize(width: 200, height: 133))
    blurredEffectView.frame = effectBounds
    blurredEffectView.layer.cornerRadius = 30.0
    blurredEffectView.clipsToBounds = true
    let label = UILabel(frame: effectBounds)
    label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    label.textAlignment = .center
    label.text = text
    label.font = label.font.withSize(40.0)
    label.textColor = UIColor.black
    
    view.addSubview(blurredEffectView)
    view.addSubview(label)
    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false){ _ in
        UIView.transition(with: blurredEffectView, duration: 0.5, options: [.transitionCrossDissolve],
                          animations: {blurredEffectView.alpha = 0}){ _ in
                            blurredEffectView.removeFromSuperview()
        }
        UIView.transition(with: label, duration: 0.5, options: [.transitionCrossDissolve],
                          animations: {label.alpha = 0}){ _ in
                            label.removeFromSuperview()
        }
    }
}

func getArtworkIconWithDefaults(using item:MPMediaItem) -> UIImage{
    if item.artwork != nil {
        return item.artwork!.image(at: CGSize(width:30,height:30))!
    }
    return UIImage(named: "guitarIcon")!
}

func generateBarChartData(with data: Dictionary<Int,Int>, andTitle title:String) -> BarChartData{
    var dataSet: BarChartDataSet!
    var dataArr = [BarChartDataEntry]()
    for (key,val) in data{
        dataArr.append(BarChartDataEntry(x: Double(key), y: Double(val)))
    }
    dataSet = BarChartDataSet(values: dataArr, label: title)
    return BarChartData(dataSet: dataSet)
}

func getStringFromDate(with date:Date) -> String{
    return  String(Calendar.current.component(.year, from: date)) +
            String(Calendar.current.component(.month, from: date)) +
            String(Calendar.current.component(.day, from: date))
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
    
    func removeBlurEffect(){
        if let blurView = self.subviews.first as? UIVisualEffectView{
            blurView.removeFromSuperview()
        }
    }
}

