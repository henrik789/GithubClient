

import Foundation



class Networking {
    let dataR = ""
    var userName = UserName()
    
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
                print("Error user", parsingError)
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
                print("Error repo", parsingError)
            }
        }
        task.resume()
    }
    
//    func downloadDetails(repoURL: String, completion: @escaping ([RepoDetails], Error?) -> Void){
//        guard let url = URL(string: repoURL) else {return}
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let dataResponse = data,
//                error == nil else {
//                    print(error?.localizedDescription ?? "Response Error")
//                    return }
//            do{
//                let decoder = JSONDecoder()
//                let repos = try decoder.decode([RepoDetails].self, from: dataResponse)
//                var model = [RepoDetails]()
//                for dic in jsonArray{
//                    model.append(User(dic)) // adding now value in Model array
//                }
//                print(model[0].userId) // 1211
//
//                print(dataResponse)
//                completion(repos, error)
//            } catch let parsingError {
//                print("Error", parsingError)
//            }
//
//        }
//        task.resume()
//
//    }
    

    
    func downloadDetails(repoURL: String, completion: @escaping ([RepoDetails], Error?) -> Void){
guard let url = URL(string: repoURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                for dict in jsonArray{
                    guard let title = dict["commit"] as? String else { return }
                    
                    print(title) //Output
                }
//               var model = [RepoDetails]()as? [String: Any]
//                for dic in jsonArray{
//                    model.append(RepoDetails(from: dic))
//                }
                
//                model = jsonArray.compactMap{ (dictionary) in
//                return RepoDetails()
//                }
//                print(model[0].commit.message)

            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
}





