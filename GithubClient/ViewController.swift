
import UIKit

private let badResponseError = NSError(domain: "Bad network response", code: 2, userInfo: nil)


class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var user = User()
     var repos: [Repos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        download()
        loadData()
        
    }
    
    func loadData() {
        updateRepos { (error) in
            print("Repos:...." , self.repos)
            self.textView.text = self.repos[12].name
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
