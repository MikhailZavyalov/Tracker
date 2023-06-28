import Foundation

final class CategoryListModel {
    @Observable
    var allCategories: [TrackerCategory] = []

    private var observation: NSKeyValueObservation?

    init() {
        observation = CoreDataStorage.shared.observe(
            \.trackerCategories,
             options: [.initial]
        ) { [weak self] storage, _ in
            self?.allCategories = storage.trackerCategories
        }
    }

    func addCategory(categoryTitle: String) {
        try! CoreDataStorage.shared.add(trackerCategory: TrackerCategory(name: categoryTitle, trackers: []))
    }
}
