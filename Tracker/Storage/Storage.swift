import Foundation

private let useCoreData = false

protocol StorageProtocol: AnyObject {
    var trackerCategories: [TrackerCategory] { get set }
    var trackerRecords: [TrackerRecord] { get set }
}

final class Storage {
    static let shared: StorageProtocol = {
//        if useCoreData {
//            return CoreDataStorage()
//        } else {
            return UserDefaultsStorage()
//        }
    }()
}
