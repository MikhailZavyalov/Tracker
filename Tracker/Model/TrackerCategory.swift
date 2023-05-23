import Foundation

struct TrackerCategory: Codable {
    let name: String
    var trackers: [Tracker]
}
