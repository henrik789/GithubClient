
import Foundation
import Auth0

class SessionManager {
    
    static let shared = SessionManager()
    private let authentication = Auth0.authentication()
    let credentialsManager: CredentialsManager!
    var profile: UserInfo?
    var credentials: Credentials?
    var userName = UserName()
    
    init () {
        self.credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        _ = self.authentication.logging(enabled: true) // API Logging
    }
    
    func retrieveProfile(_ callback: @escaping (String, Error?) -> ()) {
        guard let accessToken = self.credentials?.accessToken
            else { return callback("",CredentialsManagerError.noCredentials) }
        self.authentication
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    callback(accessToken, nil)
                case .failure(let error):
                    callback("", error)
                }
        }
    }
    
    
    
    func download(nickName: String, completion: @escaping (UserName) -> Void){
        let headers = ["authorization": "Bearer \(nickName)"]
        let request = NSMutableURLRequest(url: NSURL(string: "https://clientdemohenrik.eu.auth0.com/userinfo")! as URL,
                                          cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            do {
                let user = try JSONDecoder().decode(UserName.self, from: dataResponse)
                completion(user)
            }
            catch let parsingError {
                print(parsingError)
            }
        }
        dataTask.resume()
    }
    
    func logout() -> Bool {
        self.credentials = nil
        return self.credentialsManager.clear()
    }
    
    func store(credentials: Credentials) -> Bool {
        self.credentials = credentials
        return self.credentialsManager.store(credentials: credentials)
    }
}


