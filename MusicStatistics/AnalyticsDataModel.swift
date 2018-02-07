//
//  AnalyticsDataModel.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 2/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreData

func storeLastLaunchDate(){
    UserDefaults.standard.set(Date(), forKey: "lastLaunchDate")
}

func getLastLaunchDate() -> Date {
    return UserDefaults.standard.object(forKey: "lastLaunchDate") as! Date
}

func isLastLaunchDateNil() -> Bool {
    return UserDefaults.standard.object(forKey: "lastLaunchDate") == nil
}

/**
 If first launch
    Fetch and store data from the previous date
 Else
    Fetch data from current day
        Edit if needed
    Add to database
 
 */
class AnalyticsDate: NSManagedObject{
    
    class func addNewEntry(with values:[Int], in context:NSManagedObjectContext){
         //reate a new entry in database due to new date
//        if getMonthAndDayFromDate(with: Date()) != getMonthAndDayFromDate(with: getLastLaunchDate()){
//
//        }
        let newDate = AnalyticsDate(context: context)
        newDate.date = Date()
        let newDataEntry = AnalyticsDataEntry(context: context)
        newDataEntry.songsListened = Int32(values[0])
        newDataEntry.minutesListened = Int32(values[1])
        newDataEntry.diffAlbumListened = Int32(values[2])
        newDataEntry.diffArtistListened = Int32(values[3])
        newDate.dataEntry = newDataEntry
    }
    
    class func retrieveAnalyticsData() -> Dictionary<String,[Int]>{
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        request.predicate = NSPredicate(format: "date < %@")
        if isLastLaunchDateNil(){
        }
    }
    
    class func editAnalyticsData(){
        
    }
}

class AnalyticsDataEntry: NSManagedObject{}
