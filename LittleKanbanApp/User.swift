import UIKit
import CoreData

class User: NSManagedObject {
    
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
    
    //added surname accessor
    var surname : String? {
        set {
            if newValue != primitiveValue(forKey: "surname") as? String {
                willChangeValue(forKey: "surname")
                setPrimitiveValue(newValue, forKey: "surname")
                didChangeValue(forKey: "surname")
            }
        }
        
        get {
            return primitiveValue(forKey: "surname") as? String
        }
    }

    
    //added email accessor
    var email : String? {
        set {
            if newValue != primitiveValue(forKey: "email") as? String {
                willChangeValue(forKey: "email")
                setPrimitiveValue(newValue, forKey: "email")
                didChangeValue(forKey: "email")
            }
        }
        
        get {
            return primitiveValue(forKey: "email") as? String
        }
    }
    
    //added profilename accessor
    var profilename : String? {
        set {
            if newValue != primitiveValue(forKey: "profilename") as? String {
                willChangeValue(forKey: "profilename")
                setPrimitiveValue(newValue, forKey: "profilename")
                didChangeValue(forKey: "profilename")
            }
        }
        
        get {
            return primitiveValue(forKey: "profilename") as? String
        }
    }
    
    //added profilename accessor
    var password : String? {
        set {
            if newValue != primitiveValue(forKey: "password") as? String {
                willChangeValue(forKey: "password")
                setPrimitiveValue(newValue, forKey: "password")
                didChangeValue(forKey: "password")
            }
        }
        
        get {
            return primitiveValue(forKey: "password") as? String
        }
    }

}
