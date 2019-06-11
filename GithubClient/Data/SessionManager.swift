
import Foundation
import Auth0

class SessionManager {
    static let shared = SessionManager()
    private let authentication = Auth0.authentication()
    let credentialsManager: CredentialsManager!
    var profile: UserInfo?
    var credentials: Credentials?
    //    var patchMode: Bool = false
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
                    //                    self.download(nickName: accessToken)
                    
                    print(accessToken)
                    print("*- - -* Profil info: ", profile.name as Any)
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
                let httpResponse = response as? HTTPURLResponse
                let user = try JSONDecoder().decode(UserName.self, from: dataResponse)
                completion(user)
                print("User: ", user.nickname)
                print(httpResponse as Any)
            }
            catch let parsingError {
                print(parsingError)
            }
            
        }
        dataTask.resume()
    }
    
    //    func renewAuth(_ callback: @escaping (Error?) -> ()) {
    //        // Check it is possible to return credentials before asking for Touch
    //        guard self.credentialsManager.hasValid() else {
    //            return callback(CredentialsManagerError.noCredentials)
    //        }
    //        self.credentialsManager.credentials { error, credentials in
    //            guard error == nil, let credentials = credentials else {
    //                return callback(error)
    //            }
    //            self.credentials = credentials
    //            callback(nil)
    //        }
    //    }
    
    func logout() -> Bool {
        // Remove credentials from KeyChain
        self.credentials = nil
        return self.credentialsManager.clear()
    }
    
    func store(credentials: Credentials) -> Bool {
        self.credentials = credentials
        // Store credentials in KeyChain
        return self.credentialsManager.store(credentials: credentials)
    }
}

//func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
//    guard
//        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
//        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
//        else {
//            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
//            return nil
//    }
//
//    guard
//        let clientId = values["ClientId"] as? String,
//        let domain = values["Domain"] as? String
//        else {
//            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
//            print("File currently has the following entries: \(values)")
//            return nil
//    }
//    return (clientId: clientId, domain: domain)
//}
