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
 Update the database with appropriate inputs
 */
func updateAnalyticsDatabase(with mostRecentlyPlayedDate:Date, andData dataDescriptorValues: [Int], in context:NSManagedObjectContext){
    let mostRecentTitle = getStringFromDate(with: mostRecentlyPlayedDate)
    if (mostRecentTitle != getStringFromDate(with: Date())){
        if AnalyticsDate.doesDataEntryExist(with: mostRecentTitle, in: context){
            AnalyticsDate.editAnalyticsData(using: (mostRecentTitle,dataDescriptorValues), in: context)
        } else {
            AnalyticsDate.addNewEntryAtDate(with: dataDescriptorValues, andDate: mostRecentlyPlayedDate, in: context)
        }
    } else if ((getLastLaunchDate() == nil || getLastLaunchDate() != getStringFromDate(with: Date()))
        && !AnalyticsDate.doesDataEntryExist(with: getStringFromDate(with: Date()), in: context)){
        // add new entry
        AnalyticsDate.addNewEntry(with: dataDescriptorValues, in: context)
        storeLastLaunchDate()
    } else { // edit entry
        AnalyticsDate.editAnalyticsData(using:
            (getStringFromDate(with: Date()),dataDescriptorValues), in: context)
    }
    try? context.save()
}

func obtainAnalyticsGraphData(from lowerBound: Date, to upperBound: Date, withIndex tappedIndex: Int,in context: NSManagedObjectContext) -> ([String],[Int]){
    let data = AnalyticsDate.retrieveAnalyticsData(from: lowerBound, to: upperBound, in: context)
    var tempX = [String]()
    var tempY = [Int]()
    for (date, numbers) in data{
        tempX.append(convertAnalyticsDateToReadableText(with: date))
        tempY.append(numbers[tappedIndex])
    }
    return (tempX,tempY)
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
    
    class func addNewEntryAtDate(with values:[Int], andDate dateVal:Date, in context:NSManagedObjectContext){
        //reate a new entry in database due to new date
        let newDate = AnalyticsDate(context: context)
        newDate.date = getStringFromDate(with: dateVal)
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
    
    /**
     Obtain data from date range
    */
    class func retrieveAnalyticsData(from lowerBound: Date, to upperBound: Date, in context: NSManagedObjectContext) -> [(String, [Int])]{
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        var dataArr = [(String, [Int])]()
        let descriptor = NSSortDescriptor(key: "date", ascending: false)
        request.predicate = NSPredicate(format: "date > %@ && date <= %@", getStringFromDate(with: lowerBound), getStringFromDate(with: upperBound))
        request.sortDescriptors = [descriptor]
        do {
            let matches = try context.fetch(request)
            for item in matches{
                let var1 = Int(item.dataEntry?.songsListened ?? 0)
                let var2 = Int(item.dataEntry?.minutesListened ?? 0)
                let var3 = Int(item.dataEntry?.diffAlbumListened ?? 0)
                let var4 = Int(item.dataEntry?.diffArtistListened ?? 0)
                dataArr.append((item.date ?? "", [var1,var2,var3,var4]))
            }
        } catch {
            print(error)
        }
        return dataArr
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
    
    class func doesRangeContainValue(from lowerBound: Date, to upperBound: Date, in context: NSManagedObjectContext) -> Bool{
        let request: NSFetchRequest<AnalyticsDate> = AnalyticsDate.fetchRequest()
        request.predicate = NSPredicate(format: "date > %@ && date <= %@", getStringFromDate(with: lowerBound), getStringFromDate(with: upperBound))
        do {
            let matches = try context.fetch(request)
            return matches.count > 0
        } catch {
            print(error)
        }
        return false
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
