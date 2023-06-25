import Foundation

class TrackerCategory: NSObject, Codable {
    let name: String
    var trackers: [Tracker]
    
    internal init(name: String, trackers: [Tracker]) {
        self.name = name
        self.trackers = trackers
    }
}
