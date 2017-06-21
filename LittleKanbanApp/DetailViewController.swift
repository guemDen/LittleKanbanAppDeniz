import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var markerView: UIView!
    
    @IBOutlet weak var buttonChangeColumn : UIButton!
    
    var column : LittleKanbanColumn {
        return card.value(forKey: "littleKanbanColumn") as! LittleKanbanColumn
    }
    
    var board : LittleKanbanBoard {
        return column.value(forKey: "littleKanbanBoard") as! LittleKanbanBoard
    }
    
    var card : LittleKanbanCard!
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == descriptionTextField {
            card.detail = descriptionTextField.text
        }
    }
    
    @IBAction func textValueChanged( _ sender : AnyObject?) {
        
        if let sender = sender as? UITextField {
            
            if sender == nameTextField {
                card.name = nameTextField.text
            }
        }
    }
    
    @IBAction func deleteCard( _ sender : AnyObject? ) {
        Data.moc.delete(card)
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Segue to the columnPicker when the change column button is clicked or segue to the colorPicker when the change color button is clicked. 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Send data to the next view controller
        if segue.identifier == "columnPicker" {
            let destinationVC = segue.destination as! ColumnPicker
            destinationVC.card = card
            destinationVC.board = board
            
        } else if segue.identifier == "colorPicker" {
            
            let destinationVC = segue.destination as! ColorPicker
            destinationVC.card = card
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        markerView.backgroundColor = card.markerColor        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text? = card.name ?? ""

        descriptionTextField.text? = card.detail ?? ""
        
        buttonChangeColumn.isEnabled = board.littleKanbanColumns.count > 1
    }
    
    /*
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
        super.viewWillAppear(animated)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    //MARK: - Text Field Delegate
    
    //Some animation logic when a keyboard is used in the detail view. The animation pushes the screen above the keyboard. But the logic is not needed so far. We need this logic then when for example a text field is used at the bottom of the detail view.
    func animateVerticalPosition(_ y: CGFloat){
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: { (finished: Bool) in
        })
 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        animateVerticalPosition(0)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.frame.origin.y + textField.frame.size.height > view.frame.size.height / 2 {
            let y = ( view.frame.size.height / 2 ) - textField.frame.origin.y - textField.frame.size.height
            animateVerticalPosition(y)
        }
        return true
    }
    
}
