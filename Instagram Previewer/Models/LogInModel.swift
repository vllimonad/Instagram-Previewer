//
//  LogInModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInModel{
    
    var user: User!
    var longLivedToken: LongLivedToken! {
        didSet {
            NotificationCenter.default.post(Notification(name: Notification.Name.accessTokenWasObtained))
        }
    }
    
    func getAccessToken(for code: String) {
        let body = "client_id=348133480999841&client_secret=deae2d2af8d9e01e52226d4905c5b513&grant_type=authorization_code&redirect_uri=https://socialsizzle.herokuapp.com/auth/&code=" + code
        var urlRequest = URLRequest(url: URL(string: "https://api.instagram.com/oauth/access_token")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let user = try? JSONDecoder().decode(User.self, from: data) else { return }
            DispatchQueue.main.async {
                self.user = user
                self.getLongLivedAccessToken()
            }
        }
        task.resume()
    }
    
    func getLongLivedAccessToken() {
        let urlString = "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=deae2d2af8d9e01e52226d4905c5b513&access_token=" + user.access_token
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let token = try? JSONDecoder().decode(LongLivedToken.self, from: data) else { return }
            self.longLivedToken = token
            print(self.longLivedToken.access_token)
        }
        task.resume()
    }
}


extension Notification.Name {
    static let accessTokenWasObtained = Notification.Name("accessTokenWasObtained")
    static let dataWasObtained = Notification.Name("dataWasObtained")
}
