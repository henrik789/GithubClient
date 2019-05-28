
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var userID = ""

    
    @IBAction func loginButton(_ sender: Any) {
        if let userID = usernameText.text {
            performSegue(withIdentifier: "LoginToUserView", sender: userID)
        }
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "UserVC")
//        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToUserView" {
            let destinationVC = segue.destination as! UserViewController
            destinationVC.userID = sender as! String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 20
        
    }
    


}
