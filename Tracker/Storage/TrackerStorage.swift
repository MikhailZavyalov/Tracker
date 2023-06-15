//import Foundation
//import CoreData
//
//final class CoreDataStorage {
//    
//}
//
//final class TrackerStorage {
//    private let context: NSManagedObjectContext
//
//    convenience override init() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        self.init(context: context)
//    }
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//        let fetchRequest = EmojiMixCoreData.fetchRequest()
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(keyPath: \EmojiMixCoreData.emojis, ascending: true)
//        ]
//        
//        fetchedResultsController = NSFetchedResultsController<EmojiMixCoreData>(
//            fetchRequest: fetchRequest,
//            managedObjectContext: context,
//            sectionNameKeyPath: nil,
//            cacheName: nil
//        )
//        super.init()
//        fetchedResultsController.delegate = self
//        try! fetchedResultsController.performFetch()
//    }
//    
//    func addNewEmojiMix(_ emojiMix: EmojiMix) throws {
//        let emojiMixCoreData = EmojiMixCoreData(context: context)
//        emojiMixCoreData.emojis = emojiMix.emojis
//        emojiMixCoreData.colorHex = uiColorMarshalling.hexString(from: emojiMix.backgroundColor)
//        try context.save()
//    }
//    
//    func fetchEmojiMixes() throws -> [EmojiMix] {
//        let fetchRequest = EmojiMixCoreData.fetchRequest()
//        let emojiMixesFromCoreData = try context.fetch(fetchRequest)
//        return try emojiMixesFromCoreData.map { try self.emojiMix(from: $0) }
//    }
//}
