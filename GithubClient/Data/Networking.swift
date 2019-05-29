

import Foundation



class Networking {

    func download(userID: String, completion: @escaping (User, Error?) -> Void){
        guard let url = URL(string: "https://api.github.com/users/\(userID)") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: dataResponse)
                completion(user, error)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func downloadRepos(userID: String, completion: @escaping ([Repos], Error?) -> Void){
        guard let url = URL(string: "https://api.github.com/users/\(userID)/repos") else {return}
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

struct User: Codable {
    var name: String = ""
    var id: Int = 0
    var public_repos: Int = 0
    var bio: String = ""
    var login: String = ""
}

struct Repos: Codable {
    let name: String?
    let description: String?
    let created_at: String?
}


