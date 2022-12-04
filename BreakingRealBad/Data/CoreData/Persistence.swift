import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    private (set)var container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BreakingRealBad")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
