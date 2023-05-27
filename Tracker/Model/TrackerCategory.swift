import Foundation

struct TrackerCategory: Codable, Equatable {
    let name: String
    var trackers: [Tracker]
}
