

import Foundation



//class Networking {
//
//    
//    func addRequest(_ request: Request, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: request.url){ (data, response, error) in
//            completion(data, response, error)
////            print("Data: " , data, "Response: ",  response, "Error:",  error)
//        }
//        task.resume()
//    }
//}
//
//enum Request {
//    case getUsers
//    case getImages
//    case getBigImages
//}
//
//extension Request {
//    var url: URL {
//        switch self {
//        case .getImages:
//            return URL(string: "https://api.github.com/users/henrik789")!
//        case .getBigImages:
//            return URL(string: "https://picsum.photos/400/?random")!
//        case .getUsers:
//            return URL(string: "https://jsonplaceholder.typicode.com/users")!
//        }
//    }
//}

struct User: Codable {
    var name: String = ""
    var id: Int = 0
    var public_repos: Int = 0
    var bio: String = ""
}

struct Repos: Codable {
    let name: String?
    let description: String?
    let created_at: String?
}


