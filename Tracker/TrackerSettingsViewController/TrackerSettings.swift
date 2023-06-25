import Foundation

struct TrackerSettings {
    var color: Tracker.Color?
    var title: String?
    var emoji: String?
    var categoryTitle: String?
    var daysOfWeek: Set<Tracker.WeekDay>
    
    static let empty = TrackerSettings(daysOfWeek: Set())
    
    func makeTracker() -> Tracker? {
        guard
            let color,
            let title,
            title.isEmpty == false,
            let emoji,
            emoji.isEmpty == false,
            let categoryTitle,
            categoryTitle.isEmpty == false,
            daysOfWeek.isEmpty == false
        else { return nil }
        
        return Tracker(
            id: UUID(),
            color: color,
            title: title,
            emoji: emoji,
            categoryTitle: categoryTitle,
            daysOfWeek: daysOfWeek,
            creationDate: Date()
        )
    }
}
