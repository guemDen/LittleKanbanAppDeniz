import UIKit
import CoreData

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    var user : User?
    
    func getUserRecord(name: String!) -> User? {
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "name=[cd]%@", name)
        
        do {
            let users = try Data.moc.fetch(request)
            if users.count == 1 {
                
                return users.first
            }
            
        } catch  {
            
        }
        
        return nil
 
    }

    @IBAction func createAccount( _ sender : AnyObject?) {
        
        //Validate userName-text-field
        guard let userName = usernameTextField.text, userName.isEmpty == false else {
            //ToDo: error message
            return
        }
        
        //The user must not exist, if not show a error message.
        if getUserRecord(name: userName ) != nil {
            //ToDo: error message
            return
        }
        
        //Validate password-text-field
        guard let pw1 = passwordTextField.text, pw1.isEmpty == false else {
            //ToDo: error message
            return
        }
        
        //Validate verifyPassword-text-field
        guard let pw2 = verifyPasswordTextField.text, pw2.isEmpty == false else {
            //ToDo: error message
            return
        }
        
        //Validate both passwords equal, if not show a error message.
        guard pw1 == pw2 else {
            //ToDo: error message
            return
        }

        //Create a NSEntitiyDescription entity for the user.
        let entity = NSEntityDescription.entity(forEntityName: "User", in: Data.moc)
        //Create the user, for assigning its name and password.
        user = User(entity: entity!, insertInto: Data.moc)
        //Set the user name
        user!.name = userName
        //Set the password
        user!.password = pw1
        
        
        //Validation is done
        
        self.performSegue(withIdentifier: "toBoardList", sender: self)

    }

    //Automatically called with self.performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Send data to next view controller
        if segue.identifier == "toBoardList" {
            //Assign the user to the class variable so that it is available for the next vc
            //and segue to the BoardListViewController.
            guard let user = user else { return }
            let destinationVC = segue.destination as! BoardListViewController
            destinationVC.user = user
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
}
