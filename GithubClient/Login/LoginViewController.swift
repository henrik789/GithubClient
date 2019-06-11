
import UIKit
import Auth0


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    var userID = ""
    var sessionManager = SessionManager()
    var userName = UserName()
    
    @IBAction func loginButton(_ sender: Any) {
        
        //        SessionManager.shared.patchMode = false
        showLogin()
        loginButton.titleLabel?.text = "Log out"
        if sessionManager.logout(){
            loginButton.setTitle("Login", for: .normal)
        }
        //        if let userID = usernameText.text {
        //            performSegue(withIdentifier: "LoginToUserView", sender: userID)
        //        }
    }
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "LoginToUserView" {
    //            let destinationVC = segue.destination as! UserViewController
    //            destinationVC = sender as! String
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func showLogin() {
        //        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
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
                            DispatchQueue.main.async {
                                guard error == nil else {
                                    print("Failed to retrieve profile: \(String(describing: error))")
                                    return self.showLogin()
                                }
                                print("LOGIN: ", userID)
                                self.sessionManager.download(nickName: userID, completion: { (userName) in
                                    DispatchQueue.main.async{
                                        self.userName = userName
                                        print("Username: ", self.userName.nickname)
                                        self.performSegue(withIdentifier: "LoginToUserView", sender: self.userName.nickname)
                                    }
                                })
                                
                                
                            }
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
    
    //    fileprivate func checkToken(callback: @escaping () -> Void) {
    //
    //        SessionManager.shared.renewAuth { error in
    //            DispatchQueue.main.async {
    //
    //                    guard error == nil else {
    //                        print("Failed to retrieve credentials: \(String(describing: error))")
    //                        return callback()
    //                    }
    //                    SessionManager.shared.retrieveProfile { error in
    //                        DispatchQueue.main.async {
    //                            guard error == nil else {
    //                                print("Failed to retrieve profile: \(String(describing: error))")
    //                                return callback()
    //                            }
    //                            self.performSegue(withIdentifier: "LoginToUserView", sender: nil)
    //                        }
    //
    //                }
    //            }
    //        }
    //    }
    
}
