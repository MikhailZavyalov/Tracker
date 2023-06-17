import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    private func wipe() {
        let fetchRequests: [NSFetchRequest<NSFetchRequestResult>] = [
            NSFetchRequest(entityName: "TrackerRecordCoreData"),
            NSFetchRequest(entityName: "TrackerCoreData"),
            NSFetchRequest(entityName: "TrackerCategoryCoreData")
        ]
        let deleteRequests = fetchRequests.map { NSBatchDeleteRequest(fetchRequest: $0) }
        let context = persistentContainer.viewContext
        
        do {
            try deleteRequests.forEach {
                try context.execute($0)
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

