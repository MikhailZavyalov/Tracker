import Foundation

struct TrackerRecord: Codable, Hashable {
    let trackerId: UUID
    let date: Date
}

extension TrackerRecord {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.trackerId == rhs.trackerId
        && Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
    }
}
