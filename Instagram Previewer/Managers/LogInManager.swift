//
//  LogInModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInManager{
    
    static let shared = LogInManager()
    
    private let tokenUrlString = "https://api.instagram.com/oauth/access_token"
    private let tokenRequestBody = "client_id=348133480999841&client_secret=deae2d2af8d9e01e52226d4905c5b513&grant_type=authorization_code&redirect_uri=https://socialsizzle.herokuapp.com/auth/&code="
    private let longLivedTokenUrlString = "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=deae2d2af8d9e01e52226d4905c5b513&access_token="
    
    var profile: Profile!
    var longLivedToken: LongLivedToken! {
        didSet {
            NotificationCenter.default.post(Notification(name: Notification.Name.accessTokenWasObtained))
        }
    }
    
    func getAccessToken(for code: String) {
        let body = tokenRequestBody + code
        var urlRequest = URLRequest(url: URL(string: tokenUrlString)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let profile = try? JSONDecoder().decode(Profile.self, from: data) else { return }
            DispatchQueue.main.async {
                self.profile = profile
                self.getLongLivedAccessToken()
            }
        }.resume()
    }
    
    func getLongLivedAccessToken() {
        let urlRequest = URLRequest(url: URL(string: longLivedTokenUrlString + profile.access_token)!)
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let token = try? JSONDecoder().decode(LongLivedToken.self, from: data) else { return }
            DispatchQueue.main.async {
                self.longLivedToken = token
            }
        }.resume()
    }
}
