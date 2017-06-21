import UIKit

class ColorPicker: UIViewController {

    //Define some colors
    static var colors : [UIColor] {
        return [
            UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1.0),
            UIColor(red: 0, green: 1.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 102.0/255.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1.0),
            UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 1.0),
            UIColor(red: 102.0/255, green: 204.0/255, blue: 1.0, alpha: 1.0),
        ]
    }
    
    var card : LittleKanbanCard!
    
    @IBOutlet weak var buttonCancel : UIButton!
    
    @IBAction func cancel( _ sender : AnyObject? ) {
        dismiss(animated: true) {}
    }
    
    @IBAction func didSelectColor( _ sender: AnyObject? ) {
        
        if let sender = sender as? UIButton {
            card.mark = sender.tag
        }
        dismiss(animated: true) {}
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Running vertical position while creating the buttons.
        var y : CGFloat = 48
        
        //Running tag used as an index for referring in colors.
        var tag = 1
        
        //We create a button for each member of the colors array and add it to the view.
        for color in ColorPicker.colors {
            
            let button = UIButton(frame: CGRect(x:CGFloat(24), y: y, width: self.view.frame.size.width - CGFloat(48), height: CGFloat(40)))
            
            button.autoresizingMask = .flexibleWidth
            button.backgroundColor = color
            button.layer.cornerRadius = 5
            button.tag = tag
            button.addTarget(self, action: #selector(didSelectColor), for: .touchUpInside)
            self.view.addSubview(button)
            y += 48
            tag += 1
        }
        
        buttonCancel.frame = CGRect( x: buttonCancel.frame.origin.x, y: y, width: buttonCancel.frame.size.width, height: buttonCancel.frame.size.height)
        
    }
    
}
