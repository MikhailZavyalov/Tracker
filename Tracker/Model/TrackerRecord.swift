import Foundation

class TrackerRecord: NSObject, Codable {
    let trackerId: UUID
    let date: Date
    
    internal init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}

extension TrackerRecord {
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? TrackerRecord else { return false }
        return trackerId == other.trackerId
        && Calendar.current.isDate(date, inSameDayAs: other.date)
    }
}
