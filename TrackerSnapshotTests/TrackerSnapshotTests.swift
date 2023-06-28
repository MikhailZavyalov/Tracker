import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    func testViewController() {
        let storage = FakeCoreDataStorage()
        let vc = TrackersMainViewController(storage: storage)

        assertSnapshot(matching: vc, as: .image)
    }
}

private class FakeCoreDataStorage: NSObject, CoreDataStorageProtocol {

    @objc dynamic
    var trackerCategories = [
        TrackerCategory(
            name: "Test123123", trackers: [
                Tracker(
                    id: UUID(),
                    color: Tracker.Color(uiColor: .red),
                    title: "sdsdgs",
                    emoji: "🥃",
                    categoryTitle: "Test123123",
                    daysOfWeek: [Date().weekDay!],
                    creationDate: Date()
                )
            ]
        )
    ]

    @objc dynamic
    var trackerRecords: [TrackerRecord] = []

    func observeTrackerCategories(onChange: @escaping ([TrackerCategory]) -> Void) -> NSKeyValueObservation {
        observe(
            \.trackerCategories,
             options: [.initial]
        ) { storage, _ in
            onChange(storage.trackerCategories)
        }
    }

    func observeTrackerRecords(onChange: @escaping ([TrackerRecord]) -> Void) -> NSKeyValueObservation {
        observe(
            \.trackerRecords,
             options: [.initial]
        ) { storage, _ in
            onChange(storage.trackerRecords)
        }
    }

    func add(tracker: Tracker) throws {}
    func add(trackerRecord: TrackerRecord) throws {}
    func delete(trackerRecord: TrackerRecord) throws {}
}
