import UIKit

//Logic for shifting a card from one column to another column with a UIPickerView.
class ColumnPicker: UIViewController, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    
    var card : LittleKanbanCard!
    
    var board: LittleKanbanBoard!
    
    var columns : [LittleKanbanColumn]!
    
    @IBAction func selectColumn( _ sender : AnyObject? ) {
        let column = columns[ picker.selectedRow(inComponent: 0) ]
        card.setValue(column, forKey: "littleKanbanColumn")
        dismiss(animated: true) {}
    }
    
    @IBAction func cancel( _ sender : AnyObject? ) {
        dismiss(animated: true) {}
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return columns.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return columns[row].value(forKey: "header") as? String
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        columns = board.littleKanbanColumns.allObjects as? [LittleKanbanColumn]
        columns.sort{ $0.header! < $1.header! }
        
      
    }
    
    /*
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
        super.viewWillAppear(animated)
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
