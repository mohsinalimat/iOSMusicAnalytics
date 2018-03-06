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
    UserDefaults.standard.set(getStringFromDate(with: Date()), forKey: "lastLaunchDate")
}

/**
 returns nil if last lauch data is not found. Otherwise return the launch date
 */
func getLastLaunchDate() -> String? {
    guard UserDefaults.standard.object(forKey: "lastLaunchDate") != nil else { return nil }
    //print("Last Launched Date \(UserDefaults.standard.object(forKey: "lastLaunchDate") as! String)")
    return UserDefaults.standard.object(forKey: "lastLaunchDate") as? String
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
        let newDate = AnalyticsDate(context: context)
        newDate.date = getStringFromDate(with: Date())
        let newDataEntry = AnalyticsDataEntry(context: context)
        newDataEntry.songsListened = Int32(values[0])
        newDataEntry.minutesListened = Int32(values[1])
        newDataEntry.diffAlbumListened = Int32(values[2])
        newDataEntry.diffArtistListened = Int32(values[3])
        newDate.dataEntry = newDataEntry
    }
    
    class func manuallyAddNewEntry(with values:[Int],andName dateString:String, in context:NSManagedObjectContext){
        //reate a new entry in database due to new date
        let newDate = AnalyticsDate(context: context)
        newDate.date = dateString
        let newDataEntry = AnalyticsDataEntry(context: context)
        newDataEntry.songsListened = Int32(values[0])
        newDataEntry.minutesListened = Int32(values[1])
        newDataEntry.diffAlbumListened = Int32(values[2])
        newDataEntry.diffArtistListened = Int32(values[3])
        newDate.dataEntry = newDataEntry
    }
    
    class func retrieveAnalyticsData(in context: NSManagedObjectContext) -> Dictionary<String,[Int]>{
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        var dataDict: Dictionary<String, [Int]> = [:]
        request.predicate = NSPredicate(value: true) // return freaking everything!
        do {
            let matches = try context.fetch(request)
            let sortedMatches = matches.sorted(by: {$0.date ?? "0" < $1.date ?? "0"});
            for item in sortedMatches{
                let var1 = Int(item.dataEntry?.songsListened ?? 0)
                let var2 = Int(item.dataEntry?.minutesListened ?? 0)
                let var3 = Int(item.dataEntry?.diffAlbumListened ?? 0)
                let var4 = Int(item.dataEntry?.diffArtistListened ?? 0)
                dataDict[item.date ?? ""] = [var1,var2,var3,var4]
            }
        } catch {
            print(error)
        }
        return dataDict
    }
    
    class func editAnalyticsData(using dateData: (String,[Int]), in context: NSManagedObjectContext){
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", dateData.0)
        if var toEdit = try? context.fetch(request){
            if(toEdit.count > 1){
                for i in 0..<toEdit.count - 1{
                    context.delete(toEdit[i])
                    toEdit.remove(at: toEdit.count-1)
                }
            }
            toEdit.first!.dataEntry?.songsListened = Int32(dateData.1[0])
            toEdit.first!.dataEntry?.minutesListened = Int32(dateData.1[1])
            toEdit.first!.dataEntry?.diffAlbumListened = Int32(dateData.1[2])
            toEdit.first!.dataEntry?.diffArtistListened = Int32(dateData.1[3])
        }
    }
    
    class func doesDataEntryExist(with date:String, in context: NSManagedObjectContext) -> Bool{
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", date)
        if let fetchedDates = try? context.fetch(request){
            return fetchedDates.count > 0
        }
        return false
    }
    
    class func deleteAll(inContext context: NSManagedObjectContext){
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        request.predicate = NSPredicate(value: true) // return freaking everything!
        if let toDelete = try? context.fetch(request){
            for item in toDelete{
                context.delete(item)
            }
        }
    }
}


class AnalyticsDataEntry: NSManagedObject{}
