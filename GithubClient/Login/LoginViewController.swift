
import UIKit
import Auth0

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var userID = ""
    
    
    @IBAction func loginButton(_ sender: Any) {
        if let userID = usernameText.text {

            performSegue(withIdentifier: "LoginToUserView", sender: userID)
        }
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
        // HomeViewController.swift
        
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://clientdemohenrik.eu.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
                    print("Credentials: \(credentials)")
                }
        }
        
    }

}
