import UIKit
import CoreData

class ViewController: UIViewController {
    
    var user: User?

    let segueIdentifier: String = "toBoardList"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        self.navigationController?.isToolbarHidden = true
        super.viewDidLoad()
        //Do any additional setup after loading the view, typically from a nib.
    }
    
    //Hide the navigation bar on the login view
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
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
        
        /*  ToDo: will be required to create a user in SignupVC
        let entity = NSEntityDescription.entity(forEntityName: "User", in: Data.moc)
        
        let user = User(entity: entity!, insertInto: Data.moc)
        user.setValue(name, forKey: "name")
        
        return user
        */
    }
    
    @IBAction func loginUser(_ sender: UIButton) {
        //Send user information to the next VC
        if let username = usernameTextField.text, username.isEmpty == false {
            //Something in username
            if let fetchedUser = getUserRecord(name: username) {
                if fetchedUser.password != passwordTextField.text {
                    print("wrong pw") //todo
                    return
                }
                user = fetchedUser
                self.performSegue(withIdentifier: segueIdentifier, sender: self)
            } else {
                //ToDo: present error message, user not found
            }
            
        } else {
            //ToDo: alert the user to enter something in username
            
        }
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        //Reset text field text
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    //Automatically called with self.performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Send data to next view controller
        if segue.identifier == segueIdentifier {
            guard let user = user else { return }
            let destinationVC = segue.destination as! BoardListViewController
            destinationVC.user = user
        }
        
    }
    
}

