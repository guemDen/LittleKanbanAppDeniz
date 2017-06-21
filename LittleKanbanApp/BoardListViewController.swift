import Foundation
import UIKit
import CoreData

class BoardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var boardTableView: UITableView!
    let boardDetailIdentifier = "toBoardDetail"
    var user: User!
    
    //Reference to the submit action button of the alert.
    var currentCreateAction:UIAlertAction!
    
    //Load the boards of one user (from core data).
    lazy var boardsResults: NSFetchedResultsController<LittleKanbanBoard> = {
        let request = NSFetchRequest<LittleKanbanBoard>(entityName: "LittleKanbanBoard")
        request.predicate = NSPredicate(format: "users contains %@", self.user)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let result = NSFetchedResultsController(fetchRequest: request,
                                              managedObjectContext: Data.moc,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        result.delegate = self
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = "My Boards"
        
        boardTableView.dataSource = self
        
        boardTableView.delegate = self
        //Here i am changing the title of the navigationbar.
        navigationItem.title = user.name?.capitalized
        //Here i am changing the background color of the navigationbar.
        navigationController?.navigationBar.barTintColor = UIColor.white
        //Here i am changing the color of title text in navigation bar.
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        //Here i am changing the color of the back button in navigation bar.
        navigationController?.navigationBar.tintColor = UIColor.black
        
        do {
            try boardsResults.performFetch()
        } catch  {
            
        }
        
        boardTableView.reloadData()
    }
    
    //Show the navigation bar on the boardlist view.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
        super.viewWillAppear(animated)
    }
    
    //Switch-case statement for the actions insert, delete, update in the UITableView.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            boardTableView.insertRows(at: [newIndexPath!], with: .automatic)
            boardTableView.scrollToRow(at: newIndexPath!, at: .middle, animated: true)
        case .delete:
            boardTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            boardTableView.reloadRows(at: [indexPath!], with: .automatic)
        default : break
        }
    }
    
    //MARK:-  TABLE VIEW DELEGATE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return boardsResults.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return # of boards the user has in core data.
        return boardsResults.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = boardTableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as UITableViewCell
        let board = boardsResults.object(at: indexPath)
        //Change the text to the board name from the user's core data model!
        cell.textLabel?.text = board.name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let board = boardsResults.object(at: indexPath)
            Data.moc.delete(board)
        }
    }
    */
    
    
    //Allows to provide custom actions on the tableView letf swipe gesture. We implement that tableView delegate function in order to add a Rename button while keeping the delete button.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Logic for the rename button, which appears when the user is sliding a row of the UITableView (list of boards) to the left.
        let renameAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Rename", handler:{ action, indexpath in
            
            tableView.setEditing(false, animated: true)
            
            let board = self.boardsResults.object(at: indexPath)
            self.displayAlertToAddNewKanbanBoard(board: board)
            
        });
        //The rename button gets a green color.
        renameAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)
        
        //Logic for the delete button, which appears when the user is sliding a row of the UITableView (list of boards) to the left.
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{ action, indexpath in
            
            tableView.setEditing(false, animated: true)
            
            let board = self.boardsResults.object(at: indexPath)
            
            //If there is only one user associated to the board, then we can safely delete the board as it is not in use anymore.
            if board.users.allObjects.count <= 1 {
                Data.moc.delete(board)
            } else {
                //If not, then remove the current user from the board and leave it there for the other users.
                board.users.remove(self.user)
            }
        });
        
        return [deleteRowAction, renameAction];
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == boardDetailIdentifier {
           let indexPath = self.boardTableView.indexPath(for: sender as! UITableViewCell)
            let board = boardsResults.object(at: indexPath!)
            let destinationVC = segue.destination as! UserBoardsVC
            destinationVC.board = board
        }
    }
    
    //Added an IBAction for calling the displayAlertToAddNewKanbanBoard() function.
    //I linked the Add Button binding from the other createBoard function to this function.
    @IBAction func createBoardWithAlert(_ sender: AnyObject?){
        displayAlertToAddNewKanbanBoard( board: nil )
    }
    
    //Added a function popping up an alert for creating/renaming a new kanbanboard.
    //Argument board: send nil to create a new board, or a valid board to rename it.
    func displayAlertToAddNewKanbanBoard( board: LittleKanbanBoard? ){
        
        let title = board != nil ? "Rename Board" : "Add new Board"
        let doneTitle = board != nil ? "Rename" : "Create"
        
        let alertController = UIAlertController(title: title,
                                                message: "Write the name of the board here: ",
                                                preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: doneTitle, style: .default) { action in
            
            let boardName = alertController.textFields?.first?.text ?? ""
            
            if boardName.isEmpty == false {
                
                if let board = board {
                    board.name = boardName
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "LittleKanbanBoard", in: Data.moc)
                    let board = LittleKanbanBoard(entity: entity!, insertInto: Data.moc)
                    
                    //let users = board.users// board.value(forKey: "users") as! NSMutableSet
                    board.users.addObjects(from: [self.user])
                    board.name = boardName
                }
            }
            
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField{(textField) in textField.placeholder = "Board name"
            
            textField.addTarget(self, action: #selector (BoardListViewController.boardNameFieldDidChange(textField:)), for: .editingChanged)
        
        self.present(alertController,
                     animated: true, completion: nil)
        }
    
    }
    
    //Added this helper function for displayAlertToAddNewKanbanBoard() function.
    //Enable create button if only text field is not empty.
    func boardNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text ??
            "").characters.count > 0
    }
    
}
