

import UIKit

class RepoTableViewController: UITableViewController {

    var repoDetail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")


    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }
    



}
