import UIKit
import CoreData

class LittleKanbanCard: NSManagedObject {

    //added name accessor
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
    
    //added description accessor 
    var detail : String? {
        set {
            if newValue != primitiveValue(forKey: "detail") as? String {
                willChangeValue(forKey: "detail")
                setPrimitiveValue(newValue, forKey: "detail")
                didChangeValue(forKey: "detail")
            }
        }
        
        get {
            return primitiveValue(forKey: "detail") as? String
        }
    }
    
    //added comment accessor
    var comment : String? {
        set {
            if newValue != primitiveValue(forKey: "comment") as? String {
                willChangeValue(forKey: "comment")
                setPrimitiveValue(newValue, forKey: "comment")
                didChangeValue(forKey: "comment")
            }
        }
        
        get {
            return primitiveValue(forKey: "comment") as? String
        }
    }
    
    //added duedate accessor
    var dueDate : Date? {
        set {
            if newValue != primitiveValue(forKey: "dueDate") as? Date {
                willChangeValue(forKey: "dueDate")
                setPrimitiveValue(newValue, forKey: "dueDate")
                didChangeValue(forKey: "dueDate")
            }
        }
        
        get {
            return primitiveValue(forKey: "dueDate") as? Date
        }
    }
    
    var markerColor : UIColor! {
        get {
            //If we have a non-zero value within the colors constant array, we use it.
            if let mark = mark,  mark > 0 && mark <= ColorPicker.colors.count  {
                return ColorPicker.colors[mark - 1]
            }
            
            //If not, then we set a random value.
            let ceiling = ColorPicker.colors.count - 1
            let newMark = Int(arc4random_uniform( UInt32(ceiling) )) + 1
            setPrimitiveValue(newMark, forKey: "mark")
            
            return ColorPicker.colors[newMark - 1]
        }
    }
    
    var mark : Int? {
        set {
            if newValue != primitiveValue(forKey: "mark") as? Int {
                willChangeValue(forKey: "mark")
                setPrimitiveValue(newValue, forKey: "mark")
                didChangeValue(forKey: "mark")
            }
        }
        
        get {
            return primitiveValue(forKey: "mark") as? Int
        }
    }
    
    //added editor accessor
    var editor : String? {
        set {
            if newValue != primitiveValue(forKey: "editor") as? String {
                willChangeValue(forKey: "editor")
                setPrimitiveValue(newValue, forKey: "editor")
                didChangeValue(forKey: "editor")
            }
        }
        
        get {
            return primitiveValue(forKey: "editor") as? String
        }
    }

}
