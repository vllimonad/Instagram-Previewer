//
//  LogInModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class AccessTokenManager{
    
    static let shared = AccessTokenManager()
    
    private let tokenUrlString = "https://api.instagram.com/oauth/access_token"
    private let tokenRequestBody = "client_id=348133480999841&client_secret=deae2d2af8d9e01e52226d4905c5b513&grant_type=authorization_code&redirect_uri=https://socialsizzle.herokuapp.com/auth/&code="
    private let longLivedTokenUrlString = "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=deae2d2af8d9e01e52226d4905c5b513&access_token="
    private let refreshTokenUrlString = "https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&&access_token="
    
    private init() {}
    
    func getAccessToken(for code: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let body = tokenRequestBody + code
        var urlRequest = URLRequest(url: URL(string: tokenUrlString)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let profile = try? JSONDecoder().decode(Profile.self, from: data) else { return }
            completion(.success(profile.access_token))
        }.resume()
    }
    
    func getLongLivedAccessToken(for token: String, _ completion: @escaping (Result<LongLivedToken, Error>) -> Void) {
        let urlRequest = URLRequest(url: URL(string: longLivedTokenUrlString + token)!)
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let token = try? JSONDecoder().decode(LongLivedToken.self, from: data) else { return }
            completion(.success(token))
        }.resume()
    }
    
    func refreshToken(with token: String, _ completion: @escaping (Result<LongLivedToken, Error>) -> Void) {
        let url = URL(string: refreshTokenUrlString + token)!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let refreshedToken = try? JSONDecoder().decode(LongLivedToken.self, from: data) else { return }
            completion(.success(refreshedToken))
        }.resume()
    }
}
