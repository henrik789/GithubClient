
import UIKit

private let badResponseError = NSError(domain: "Bad network response", code: 2, userInfo: nil)


class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    var user = User()
     var repos: [Repos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        download()
        loadData()

        tableview.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableview.register(UINib.init(nibName: UserTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
    }
    
    func loadData() {
        updateRepos { (error) in
            print("Repos:...." , self.repos)
            self.tableview.dataSource = self
            self.tableview.delegate = self
            self.tableview.reloadData()
        }
    }
    
    func updateRepos(completion: @escaping (Error?) -> Void) {
         downloadRepos { (repos, error) in
            guard error == nil else {
                dispatchOnMain(completion, with: error)
                return
            }
            self.repos = repos
            dispatchOnMain(completion, with: nil)
        }
    }
    
    func download(){
        guard let url = URL(string: "https://api.github.com/users/henrik789") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: dataResponse)
                print(user.name)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func downloadRepos(completion: @escaping ([Repos], Error?) -> Void){
        guard let url = URL(string: "https://api.github.com/users/henrik789/repos") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let decoder = JSONDecoder()
                let repos = try decoder.decode([Repos].self, from: dataResponse)
                completion(repos, error)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
}

public func dispatchOnMain<T>(_ block: @escaping (T)->Void, with parameters: T) {
    DispatchQueue.main.async {
        block(parameters)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        
            cell.nameLabel.text = repos[indexPath.row].name
            nameLabel.text = user.name
        
        return cell
    }
    
    
    
    
}
