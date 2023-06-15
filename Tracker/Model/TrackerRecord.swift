import Foundation

class TrackerRecord: NSObject, Codable {
    let trackerId: UUID
    let date: Date
    
    internal init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}
