import Foundation
import UIKit
import CoreData

class UserBoardsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
   
    @IBOutlet weak var todoCollectionView: UICollectionView!
    var board: LittleKanbanBoard!
    
    //reference to the submit action button of the alert
    var currentCreateAction:UIAlertAction!

    lazy var columnsResults: NSFetchedResultsController<LittleKanbanColumn> = {
        let request = NSFetchRequest<LittleKanbanColumn>(entityName: "LittleKanbanColumn")
        request.predicate = NSPredicate(format: "littleKanbanBoard = %@", self.board)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        let result = NSFetchedResultsController(fetchRequest: request,
                                                managedObjectContext: Data.moc,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
        result.delegate = self
        return result
    }()
    
    override func viewDidLoad() {
        
        navigationItem.title = board.name?.capitalized
        
        do {
            try columnsResults.performFetch()
        } catch  {
            
        }
        
        todoCollectionView.reloadData()
    }
    
    /*
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
        super.viewWillAppear(animated)
    }*/
    
    /*
    @IBAction func createColumn(_ sender: AnyObject?){
        
        let entity = NSEntityDescription.entity(forEntityName: "LittleKanbanColumn", in: Data.moc)
        let column = LittleKanbanColumn(entity: entity!, insertInto: Data.moc)
        column.setValue(board, forKey:"littleKanbanBoard")
    }
    */
    
    //Here we need the methods insertItems and deleteItems, because that is a UICollectionView and not a UITableView.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            todoCollectionView.insertItems(at: [newIndexPath!])
            //When a new column is created, then scroll horizontally to the new column. 
            todoCollectionView.scrollToItem(at: newIndexPath!, at: .centeredHorizontally, animated: true)
        case .delete:
            todoCollectionView.deleteItems(at: [indexPath!])
        default : break
        }
    }

    // MARK: Collection View Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return columnsResults.sections!.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columnsResults.sections![section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = todoCollectionView.dequeueReusableCell(withReuseIdentifier: "todoIdentifier", for: indexPath) as! ToDoCollectionViewCell

        cell.column = columnsResults.object(at: indexPath)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? cardCell {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.card = cell.card
        }

    }
    
    // MARK: Alert
    
    //Added an IBAction for calling the displayAlertToAddNewKanbanBoard() function.
    //I linked the Add Button binding from the other createBoard function to this function.
    //Added a function popping up an alert for creating a new kanbancolumn.
    @IBAction func displayAlertToAddNewKanbanColumn(_ sender: AnyObject?){
        
        let title = "Add new Column"
        let doneTitle = "Create"
        
        let alertController = UIAlertController(title: title,
                                                message: "Write the name of your new column here: ",
                                                preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: doneTitle, style: .default){
            (action) -> Void in
            
            let columnName = alertController.textFields?.first?.text ?? ""
            
            if columnName.isEmpty == false {
                let entity = NSEntityDescription.entity(forEntityName: "LittleKanbanColumn", in: Data.moc)
                let column = LittleKanbanColumn(entity: entity!, insertInto: Data.moc)
                
                column.header = columnName
                column.littleKanbanBoard = self.board
            }
            
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField{(textField) in textField.placeholder = "Column name"
            
            textField.addTarget(self, action: #selector (BoardListViewController.boardNameFieldDidChange(textField:)), for: .editingChanged)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //Added this helper function for displayAlertToAddNewKanbanBoard() function.
    //Enable create button if only text field is not empty.
    func boardNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text ??
            "").characters.count > 0
    }
    
}
