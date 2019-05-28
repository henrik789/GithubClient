
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

    
    @IBAction func loginButton(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "UserVC")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    


}
