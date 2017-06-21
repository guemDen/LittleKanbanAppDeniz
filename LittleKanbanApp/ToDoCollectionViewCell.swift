import UIKit
import CoreData

class cardCell : UITableViewCell {
    
    var card: LittleKanbanCard!
    
    @IBOutlet var markerView : UIView!
    
}


class ToDoCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //Added IBOutlet for the name of a card
    //The rest of the information is presented in detail view of an card!!! for example the description of an card and so on ...
    @IBOutlet var name: UITextField!
    
    @IBOutlet var cardsTableView : UITableView!
    
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    
    //Reference to the submit action button of the alert
    var currentCreateAction:UIAlertAction!
    
    lazy var cardsResults: NSFetchedResultsController<LittleKanbanCard> = {
        
        let request = NSFetchRequest<LittleKanbanCard>(entityName: "LittleKanbanCard")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let result = NSFetchedResultsController(fetchRequest: request,
                                                managedObjectContext: Data.moc,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
        result.delegate = self
        return result
    }()
    
    
    var column: LittleKanbanColumn! {
        
        didSet {
            name.text? = column.header ?? ""
            
            cardsResults.fetchRequest.predicate = NSPredicate(format: "littleKanbanColumn = %@", self.column)
            
            do {
                try cardsResults.performFetch()
            } catch  {
                
            }
            
            cardsTableView.reloadData()
            
            //Some programmitically UI-Styling for the Columns
            contentView.layer.borderColor = UIColor.black.cgColor
            contentView.layer.borderWidth = 0.5
        }
    }
    
    @IBAction func columnRenamed( _ sender : AnyObject? ) {
        
        column.header = name.text
    }
    
    
    @IBAction func deleteColumn( _ sender : AnyObject? ) {
        Data.moc.delete( column )
    }
    
    
    /*
    @IBAction func createCard(_ sender: AnyObject?){
        
        let entity = NSEntityDescription.entity(forEntityName: "LittleKanbanCard", in: Data.moc)
        let card = LittleKanbanCard(entity: entity!, insertInto: Data.moc)
        card.setValue(column, forKey: "littleKanbanColumn")  //todo: accessor

    }
    */
    
   
    //MARK: TABLE VIEW DELEGATE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardsResults.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return # of boards the user has in core data
        print( )
        return cardsResults.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardsTableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! cardCell
        let card = cardsResults.object(at: indexPath)
        cell.textLabel?.text = card.name
        cell.card = card
        cell.markerView.backgroundColor = card.markerColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print( sourceIndexPath, destinationIndexPath)
    }
    
    // MARK: Alert
    
    //Added an IBAction for calling the displayAlertToAddNewKanbanBoard() function.
    //Added a function popping up an alert for creating a new kanbancolumn.
    @IBAction func displayAlertToAddNewKanbanCard(_ sender: AnyObject?){
        
        let title = "Add new Card"
        let doneTitle = "Create"
        
        let alertController = UIAlertController(title: title,
                                                message: "Write the name of your new card here: ",
                                                preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: doneTitle, style: .default) { action in
            
            let cardName = alertController.textFields?.first?.text ?? ""
            
            if cardName.isEmpty == false {
                let entity = NSEntityDescription.entity(forEntityName: "LittleKanbanCard", in: Data.moc)
                let card = LittleKanbanCard(entity: entity!, insertInto: Data.moc)
                card.name = cardName
                card.setValue(self.column, forKey: "littleKanbanColumn")
            }
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField{(textField) in textField.placeholder = "Card name"
            
            textField.addTarget(self, action: #selector (BoardListViewController.boardNameFieldDidChange(textField:)), for: .editingChanged)
            
            //We need the context of the rootViewController to present the alert.
            if let root = self.window?.rootViewController {
                root.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    //Added this helper function for displayAlertToAddNewKanbanBoard() function.
    //Enable create button if only text field is not empty.
    func boardNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text ??
            "").characters.count > 0
    }
    
}

// MARK: NSFetchedResultsControllerDelegate
extension ToDoCollectionViewCell: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //One or more changes will happen on the data set; we initialize array to
        //accumulate them in order to process all the changes in batch mode.
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        //We accumulate insertions and deletions in order to process them all at once when we receive all changes.
        switch type {
            
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
            
        case .delete:
            deletedIndexPaths.append(indexPath!)
            
        case .update, .move :
            cardsTableView.reloadRows(at: [indexPath!], with: .none)
            cardsTableView.reloadRows(at: [newIndexPath!], with: .none)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //Now the fetched controller is done processing new changes, we can ask the tableView to update the display for all of them at once.
        
        cardsTableView.beginUpdates()
        
        cardsTableView.insertRows(at: insertedIndexPaths, with: .automatic)
        
        cardsTableView.deleteRows(at: deletedIndexPaths, with: .automatic)
        
        cardsTableView.endUpdates()
    }
    
}


