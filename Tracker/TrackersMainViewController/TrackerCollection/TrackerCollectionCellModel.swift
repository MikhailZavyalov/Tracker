import UIKit

struct TrackerCollectionCellModel {
    let color: UIColor
    let title: String
    let emoji: String
    let daysCompleted: Int
    let isPinned: Bool
    var isCompleted: Bool
}

extension TrackerCollectionCellModel {
    init(tracker: Tracker, trackerRecords: [TrackerRecord], chosenDate: Date) {
        self.color = tracker.color.uiColor
        self.title = tracker.title
        self.emoji = tracker.emoji
        self.isPinned = tracker.isPinned
     
        var isCompleted = false
        for record in trackerRecords {
            guard record.trackerId == tracker.id else { continue }
            if Calendar.current.isDate(chosenDate, inSameDayAs: record.date) {
                isCompleted = true
                break
            }
        }
        self.isCompleted = isCompleted
        
        var daysCompleted = 0
        for record in trackerRecords {
            guard record.trackerId == tracker.id else { continue }
            daysCompleted += 1
        }
        self.daysCompleted = daysCompleted
    }
}
