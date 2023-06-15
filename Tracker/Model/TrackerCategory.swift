import Foundation

struct TrackerCategory: Codable, Hashable {
    let name: String
    var trackers: [Tracker]
}
