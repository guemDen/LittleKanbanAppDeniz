import UIKit
import CoreData

class LittleKanbanBoard: NSManagedObject {

    var name : String? {
        set {
            if newValue != primitiveValue(forKey: "name") as? String {
                willChangeValue(forKey: "name")
                setPrimitiveValue(newValue, forKey: "name")
                didChangeValue(forKey: "name")
            }
        }
        
        get {
            return primitiveValue(forKey: "name") as? String
        }
    }
    
    var users : NSMutableSet! {
        set {
            willChangeValue(forKey: "users")
            setPrimitiveValue(newValue, forKey: "users")
            didChangeValue(forKey: "users")
        }
        get {
            return primitiveValue(forKey: "users") as? NSMutableSet ?? []
        }
    }
    
    var littleKanbanColumns : NSMutableSet! {
        set {
            willChangeValue(forKey: "littleKanbanColumns")
            setPrimitiveValue(newValue, forKey: "littleKanbanColumns")
            didChangeValue(forKey: "littleKanbanColumns")
        }
        get {
            return primitiveValue(forKey: "littleKanbanColumns") as? NSMutableSet ?? []
        }
    }
    
}

