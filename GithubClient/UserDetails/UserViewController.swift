
import UIKit

private let badResponseError = NSError(domain: "Bad network response", code: 2, userInfo: nil)


class UserViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headLabel: UILabel!
    
    var userID = ""
    var user = User()
    var repos: [Repos] = []
    var network = Networking()
    var repoDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableview.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableview.register(UINib.init(nibName: UserTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }

    
    func loadData() {
        updateRepos { (error) in
            self.tableview.reloadData()
        }
        updateUser { (error) in
            if let labelA = self.headLabel {
                labelA.text = self.user.name
            }
            if let userID = self.useridLabel {
                userID.text = "Username: " + self.user.login
            }
        }
    }
    
    func updateUser(completion: @escaping (Error?) -> Void) {
        network.download(userID: userID){ (user, error) in
            guard error == nil else {
                dispatchOnMain(completion, with: error)
                return
            }
            self.user = user
            dispatchOnMain(completion, with: nil)
        }
    }
    
    func updateRepos(completion: @escaping (Error?) -> Void) {
        network.downloadRepos(userID: userID) { (repos, error) in
            guard error == nil else {
                dispatchOnMain(completion, with: error)
                return
            }
            self.repos = repos
            dispatchOnMain(completion, with: nil)
        }
    }
    
}





public func dispatchOnMain<T>(_ block: @escaping (T)->Void, with parameters: T) {
    DispatchQueue.main.async {
        block(parameters)
    }
}


extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        let repoIndex = repos[indexPath.row]
        
        if let labelA = cell.nameLabel {
            labelA.text = repoIndex.name
        }
        if let labelB = cell.dateLabel {
            labelB.text = repoIndex.created_at
        }
        if let labelC = cell.descriptionLabel {
            labelC.text = repoIndex.description
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let repoDetail = repos[indexPath.row].name {
            performSegue(withIdentifier: "UserViewToRepoView", sender: repoDetail)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserViewToRepoView" {
            let detailsVC = segue.destination as! RepoTableViewController
            detailsVC.repoName = sender as! String
        }
    }
    
}



