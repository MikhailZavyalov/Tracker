import Foundation

final class UserDefaultsStorage: StorageProtocol {
    private let trackerCategoriesKey: String = "trackerCategoriesKey"
    private let trackerRecordsKey: String = "trackerRecordsKey"
    
    var trackerCategories: [TrackerCategory] {
        get {
            getValue(forKey: trackerCategoriesKey)
        }
        set {
            setValue(forKey: trackerCategoriesKey, value: newValue)
        }
    }
    
    var trackerRecords: [TrackerRecord] {
        get {
            getValue(forKey: trackerRecordsKey)
        }
        set {
            setValue(forKey: trackerRecordsKey, value: newValue)
        }
    }
    
    private func getValue<T: Decodable>(forKey key: String) -> [T] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let trackers = try? JSONDecoder().decode([T].self, from: data)
        else {
            return []
        }
        return trackers
    }
    
    private func setValue<T: Encodable>(forKey key: String, value: [T]) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
}

