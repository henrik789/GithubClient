
import UIKit

private let badResponseError = NSError(domain: "Bad network response", code: 2, userInfo: nil)


class ViewController: UIViewController {
    
    let networking = Networking()
    private(set) var user = User()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        updateUsers { (Error) in
        //            print(self.users)
        //        }
        download()
        
    }
    
    func download(){
        guard let url = URL(string: "https://api.github.com/users/henrik789") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                if let dictionary = jsonResponse as? [String: Any]{
                    if let name = dictionary["name"] as? String{
                        print("Name: " , name)
                    }
                }
                let decoder = JSONDecoder()
                let model = try decoder.decode(User.self, from:
                    dataResponse) //Decode JSON Response Data
                print(model)
//                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    
//    func download(){
//        guard let url = URL(string: "https://api.github.com/users/henrik789") else {return}
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let dataResponse = data,
//                error == nil else {
//                    print(error?.localizedDescription ?? "Response Error")
//                    return }
//            do{
//                //here dataResponse received from a network request
//                let jsonResponse = try JSONSerialization.jsonObject(with:
//                    dataResponse, options: [])
//                if let dictionary = jsonResponse as? [String: Any]{
//                    if let name = dictionary["name"] as? String{
//                        print("Name: " , name)
//                    }
//                }
//                print(jsonResponse) //Response result
//            } catch let parsingError {
//                print("Error", parsingError)
//            }
//        }
//        task.resume()
//    }
    
//    func updateUsers(completion: @escaping (Error?) -> Void) {
//        getUsers { (users, error) in
//            print("- -  checking - -")
//            guard error == nil else {
//                dispatchOnMain(completion, with: error)
//                return
//            }
//            self.users = users
//            dispatchOnMain(completion, with: nil)
//        }
//    }
//    
//    func getUsers(completion: @escaping ([User], Error?) -> Void) {
//        networking.addRequest(.getImages) { (data, response, error)  in
//            guard let data = data , error == nil else {
//                let error = error ?? badResponseError
//                completion([], error)
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let users = try decoder.decode([User].self, from: data)
//                completion(users, nil)
//                print(users)
//            } catch {
//                completion([], error)
//            }
//        }
//    }
//    
//    
//}
//
//public func dispatchOnMain<T>(_ block: @escaping (T)->Void, with parameters: T) {
//    DispatchQueue.main.async {
//        block(parameters)
//    }
}
