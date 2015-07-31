import UIKit
import Parse

class MyModel : PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "MyModel"
    }
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    @NSManaged var property1 : String?
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myObject = MyModel()
        myObject.addObserver(self, forKeyPath: "property1", options: .New, context: nil)
        myObject.property1 = "Hello"
        myObject.removeObserver(self, forKeyPath: "property1")
        
        // If I comment these 4 lines. myObject is happy observing the property.
        var anotherObject = MyModel()
        anotherObject.addObserver(self, forKeyPath: "property1", options: .New, context: nil)
        anotherObject.property1 = "World"
        anotherObject.removeObserver(self, forKeyPath: "property1")
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        var n : AnyObject? = change["new"]
        switch keyPath {
        case "property1" :
            println("observed MyModel.property1 with value \(n)")
        default :
            break
        }
    }
}

