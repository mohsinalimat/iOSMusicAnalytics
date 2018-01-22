//
//  AddViewLyricsModel.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreData

class Song: NSManagedObject {
    
    //does nothing if lyrics already exists, else add the lyrics
    class func addLyricsToSong(to songName: String, using lyrics:String, in context:NSManagedObjectContext){
        //create lyrics in DB
        let createdLyrics = Lyrics(context: context)
        createdLyrics.lyrics = lyrics
        let createdSong = Song(context: context)
        createdSong.song = songName
        createdSong.songToLyrics = createdLyrics
        //createdLyrics.lyricsToSongs = createdSong
    }
    
    class func getLyrics(using songName: String, in context: NSManagedObjectContext) -> String? {
        //generate a request to fetch songs
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "song = %@", songName)
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                print("matched count \(matches.count)")
                return matches[0].songToLyrics?.lyrics
            }
        } catch {
            print(error)
        }
        return "No Matches"
    }
    
    class func deleteLyrics(using songName: String, in context: NSManagedObjectContext){
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "song = %@", songName)
        if let toDelete = try? context.fetch(request){
            for item in toDelete{
                context.delete(item)
            }
        }
    }
    
}

class Lyrics: NSManagedObject{
    //does nothing if lyrics already exists, else add the lyrics
    class func addSongToLyrics(to lyrics: String, using songName:String, in context:NSManagedObjectContext){
        if getSong(using: songName, in: context) == "No Matches"{
            //create lyrics in DB
            let createdLyrics = Lyrics(context: context)
            createdLyrics.lyrics = lyrics
        }
    }
    
    class func getSong(using songName: String, in context: NSManagedObjectContext) -> String? {
        //generate a request to fetch songs
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "song = %@", songName)
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0].song
            }
        } catch {
            print(error)
        }
        return "No Matches"
    }
}
