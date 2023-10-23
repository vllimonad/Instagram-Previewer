//
//  LogInModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

class LogInModel{
    
    var user: User!
    
    func getAccessToken(for code: String) {
        let body = "client_id=348133480999841&client_secret=deae2d2af8d9e01e52226d4905c5b513&grant_type=authorization_code&redirect_uri=https://socialsizzle.herokuapp.com/auth/&code=" + code
        var urlRequest = URLRequest(url: URL(string: "https://api.instagram.com/oauth/access_token")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let user = try? JSONDecoder().decode(User.self, from: data) else { return }
            self.user = user
            print(user.access_token)
        }
        task.resume()
    }
}
