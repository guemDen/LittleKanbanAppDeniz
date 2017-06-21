import UIKit
import CoreData

class LittleKanbanColumn: NSManagedObject {

    //added header name accessor
    var header : String? {
        set {
            if newValue != primitiveValue(forKey: "header") as? String {
                willChangeValue(forKey: "header")
                setPrimitiveValue(newValue, forKey: "header")
                didChangeValue(forKey: "header")
            }
        }
        
        get {
            return primitiveValue(forKey: "header") as? String
        }
    }
    
    //added wiplimit accesor
    var wiplimit : Int? {
        set {
            if newValue != primitiveValue(forKey: "wiplimit") as? Int {
                willChangeValue(forKey: "wiplimit")
                setPrimitiveValue(newValue, forKey: "wiplimit")
                didChangeValue(forKey: "wiplimit")
            }
        }
        
        get {
            return primitiveValue(forKey: "wiplimit") as? Int
        }
    }
    
    var littleKanbanCards : NSMutableSet! {
        set {
            willChangeValue(forKey: "littleKanbanCards")
            setPrimitiveValue(newValue, forKey: "littleKanbanCards")
            didChangeValue(forKey: "littleKanbanCards")
        }
        get {
            return primitiveValue(forKey: "littleKanbanCards") as? NSMutableSet ?? []
        }
    }
    
    var littleKanbanBoard : LittleKanbanBoard? {
        
        set {
            if newValue != primitiveValue(forKey: "littleKanbanBoard") as? LittleKanbanBoard {
                willChangeValue(forKey: "littleKanbanBoard")
                setPrimitiveValue(newValue, forKey: "littleKanbanBoard")
                didChangeValue(forKey: "littleKanbanBoard")
            }
        }
        
        get {
            return primitiveValue(forKey: "littleKanbanBoard") as? LittleKanbanBoard
        }
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setValue( Date(), forKey: "dateCreated")
    }

}
