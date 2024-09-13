//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

final class APIService {
    
    static let shared = APIService()
    private let contentUrlString = "https://graph.instagram.com//me/media?fields=media_type,media_url,timestamp&access_token="
    private let userInfoUrlString = "https://graph.instagram.com//me?fields=id,username&access_token="
    
    private init() {}
    
    func getContent(with token: String, _ completion: @escaping (Result<Content, Error>) -> Void) {
        let url = URL(string: contentUrlString + token)
        let urlRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            guard let content = try? JSONDecoder().decode(Content.self, from: data) else { return }
            completion(.success(content))
        }.resume()
    }
    
    func getPhoto(_ url: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        print("URL:  \(url)")
        let urlRequest = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
    
    func getUserInfo(with token: String, _ completion: @escaping (Result<Info, Error>) -> Void) {
        let url = URL(string: userInfoUrlString + token)!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let userInfo = try? JSONDecoder().decode(Info.self, from: data) else { return }
            completion(.success(userInfo))
        }.resume()
    }
}
