
import UIKit
import Auth0


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    var userID = ""
    var sessionManager = SessionManager()
    var userName = UserName()
    var isLoggedIn = false
    
    @IBAction func loginButton(_ sender: UIButton) {
        login()
    }
    
    
    func login(){
        let hasCred = sessionManager.credentialsManager.hasValid()
        if !hasCred {
            showLogin()
            loginButton.setTitle("Logout", for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionManager.logout()
    }
    
    fileprivate func showLogin() {
        Auth0
            .webAuth()
            .scope("openid profile offline_access")
            .audience("https://clientdemohenrik.eu.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    if(!SessionManager.shared.store(credentials: credentials)) {
                        print("Failed to store credentials")
                    } else {
                        SessionManager.shared.retrieveProfile { (userID, error)  in
//                            DispatchQueue.main.async {
                                guard error == nil else {
                                    print("Failed to retrieve profile: \(String(describing: error))")
                                    return self.showLogin()
                                }
                                self.sessionManager.download(nickName: userID, completion: { (userName) in
                                    DispatchQueue.main.async{
                                        self.userName = userName
                                        print("Username: ", self.userName.nickname)
                                        self.performSegue(withIdentifier: "LoginToUserView", sender: self.userName.nickname)
                                    }
                                })
//                            }
                        }
                    }
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToUserView" {
            let userVC = segue.destination as! UserViewController
            userVC.userID = sender as! String
        }
    }
    
    
}
