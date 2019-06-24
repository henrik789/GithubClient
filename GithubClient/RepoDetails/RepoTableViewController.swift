

import UIKit

class RepoTableViewController: UITableViewController {
    

    var repoUrl = ""
    var network = Networking()
    var message = ""
    var date = ""
    var repoDetails: [RepoDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.title = "Repo Details"
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    func loadData() {
        updateRepoDetail { (error) in
            print("Repo details: " , self.repoDetails)
            print("Repo url: " , self.repoDetails[1].commit)

//            message = self.repoDetail.message
//            date = self.repoDetail.date
        }
    }
    
    func updateRepoDetail(completion: @escaping (Error?) -> Void) {
        network.downloadDetails(repoURL: repoUrl){ (repoDetails, error) in
            guard error == nil else {
                dispatchOnMain(completion, with: error)
                return
            }
            self.repoDetails = repoDetails
            dispatchOnMain(completion, with: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "reuseIdentifier")
//        cell.detailTextLabel?.text = repoDetails[indexPath.row].commiter
        cell.detailTextLabel?.text = repoUrl
//        cell.textLabel?.text = repoDetails[indexPath.row].message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}
