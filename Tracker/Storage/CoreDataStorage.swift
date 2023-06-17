import Foundation
import UIKit
import CoreData

final class CoreDataStorage: NSObject {
    static let shared = CoreDataStorage()
    
    @objc dynamic
    var trackerCategories: [TrackerCategory] = []
    @objc dynamic
    var trackerRecords: [TrackerRecord] = []
    
    private let context: NSManagedObjectContext

    private convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        try updateData()
    }
    
    func add(tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = try JSONEncoder().encode(tracker.color)
        trackerCoreData.daysOfWeek = try JSONEncoder().encode(tracker.daysOfWeek)
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.records = []
        
        let categories = try fetchCategories()
        trackerCoreData.category = categories.first {
            $0.name == tracker.categoryTitle
        }
        trackerCoreData.categoryTitle = tracker.categoryTitle
        try context.save()
        
        try updateData()
    }
    
    func add(trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = trackerCategory.name
        trackerCategoryCoreData.trackers = []
        
        try context.save()
        
        try updateData()
    }
    
    func add(trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = trackerRecord.date
        
        let trackers = try fetchTrackers()
        trackerRecordCoreData.tracker = trackers.first {
            $0.trackerId == trackerRecord.trackerId
        }

        try context.save()
        
        try updateData()
    }
    
    func delete(trackerRecord: TrackerRecord) throws {
        let records = try fetchRecords()
        let record = records.first {
            $0.tracker?.trackerId == trackerRecord.trackerId
            && Calendar.current.isDate($0.date!, inSameDayAs: trackerRecord.date)
        }
        context.delete(record!)
        try updateData()
    }
    
    private func updateData() throws {
        trackerCategories = try fetchCategories().map { $0.mapToTrackerCategory() }
        trackerRecords = try fetchRecords().map { $0.mapToTrackerRecord() }
    }
    
    private func fetchTrackers() throws -> [TrackerCoreData] {
        let fetchRequest = TrackerCoreData.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    private func fetchCategories() throws -> [TrackerCategoryCoreData] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    private func fetchRecords() throws -> [TrackerRecordCoreData] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        return try context.fetch(fetchRequest)
    }
}

extension TrackerCoreData {
    func mapToTracker() -> Tracker {
        Tracker(
            id: trackerId!,
            color: try! JSONDecoder().decode(Tracker.Color.self, from: color!),
            title: title!,
            emoji: emoji!,
            categoryTitle: categoryTitle!,
            daysOfWeek: try! JSONDecoder().decode(Set<Tracker.WeekDay>.self, from: daysOfWeek!)
        )
    }
}

extension TrackerCategoryCoreData {
    func mapToTrackerCategory() -> TrackerCategory {
        TrackerCategory(
            name: name!,
            trackers: trackers!.map { ($0 as! TrackerCoreData).mapToTracker() }
        )
    }
}

extension TrackerRecordCoreData {
    func mapToTrackerRecord() -> TrackerRecord {
        TrackerRecord(
            trackerId: tracker!.trackerId!,
            date: date!
        )
    }
}
