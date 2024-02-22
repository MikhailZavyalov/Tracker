import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    func testMainViewControllerLightAppearance() {
        let storage = FakeCoreDataStorage()
        let vc = TrackersMainViewController(storage: storage)

        assertSnapshot(matching: vc, as: .image)
    }

    func testMainViewControllerDarkAppearance() {
        let storage = FakeCoreDataStorage()
        let vc = TrackersMainViewController(storage: storage)
        vc.overrideUserInterfaceStyle = .dark

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
                    creationDate: Date(),
                    isPinned: false
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
    func delete(tracker: Tracker) throws {}
    func overwriteTracker(tracker: Tracker) throws {}
}