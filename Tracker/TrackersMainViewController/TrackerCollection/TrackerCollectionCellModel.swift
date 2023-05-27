import UIKit

struct TrackerCollectionCellModel {
    let color: UIColor
    let title: String
    let emoji: String
    let remainingDays: Int
    var isCompleted: Bool
}

extension TrackerCollectionCellModel {
    init(tracker: Tracker, trackerRecords: [TrackerRecord], date: Date) {
        self.color = tracker.color.uiColor
        self.title = tracker.title
        self.emoji = tracker.emoji
        
        var remainingDays = 0
        var currentDate = Date()
        while !tracker.daysOfWeek.contains(currentDate.weekDay!) {
            remainingDays += 1
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        self.remainingDays = remainingDays
        
        var isCompleted = false
        for record in trackerRecords {
            guard record.trackerId == tracker.id else { continue }
            if Calendar.current.isDate(currentDate, inSameDayAs: record.date) {
                isCompleted = true
                break
            }
        }
        self.isCompleted = isCompleted
    }
}
