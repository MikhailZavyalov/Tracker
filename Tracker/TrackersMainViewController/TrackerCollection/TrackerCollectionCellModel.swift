import UIKit

struct TrackerCollectionCellModel {
    let color: UIColor
    let title: String
    let emoji: String
    let remainingDays: Int
    var isCompleted: Bool
}

extension TrackerCollectionCellModel {
    init(tracker: Tracker, trackerRecords: [TrackerRecord], chosenDate: Date) {
        self.color = tracker.color.uiColor
        self.title = tracker.title
        self.emoji = tracker.emoji
     
        var isCompleted = false
        for record in trackerRecords {
            guard record.trackerId == tracker.id else { continue }
            if Calendar.current.isDate(chosenDate, inSameDayAs: record.date) {
                isCompleted = true
                break
            }
        }
        self.isCompleted = isCompleted
        print(isCompleted)
        var remainingDays = isCompleted ? 1 : 0
        var currentDate = isCompleted
        ? Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        : Date()
        while !tracker.daysOfWeek.contains(currentDate.weekDay!) {
            remainingDays += 1
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        self.remainingDays = remainingDays
        print(remainingDays)
    }
}
