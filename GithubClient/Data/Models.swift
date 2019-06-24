
import Foundation


struct User: Codable {
    var name: String = ""
    var login: String = ""
    var bio: String = ""
}

struct UserName: Codable {
    var nickname: String = ""
}


struct Repos: Codable {
    let name: String?
    let description: String?
    let created_at: String?
    let commits_url: String?
    
}

struct RepoDetails: Codable {
//    var url: String
//    var commiter: String
//    var sha: String
    var commit: Commit
    init(commit: Commit) {
        self.commit = commit
    }

}


struct Commit: Codable {
    
    let message: String = ""
}

