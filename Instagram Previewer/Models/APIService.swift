//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation
import AVFoundation
import AssetsLibrary

extension Notification.Name {
    static let accessTokenWasObtained = Notification.Name("accessTokenWasObtained")
    static let contentWasObtained = Notification.Name("contentWasObtained")
    static let dataWasObtained = Notification.Name("dataWasObtained")
    static let tokenWasRefreshed = Notification.Name("tokenWasRefreshed")
    static let tokenExpired = Notification.Name("tokenExpired")
}

final class APIService {
    
    var userInfo: Info!
    var access_token: String!
    var content: Content!
    var photos: [Data]! {
        didSet {
            if self.photos.count + 1 == self.content.data.count {
                NotificationCenter.default.post(Notification(name: Notification.Name.dataWasObtained))
            }
        }
    }
    
    func getContent() {
        let url = URL(string: "https://graph.instagram.com//me/media?fields=media_type,media_url,timestamp&access_token=" + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, error == nil,
                    let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 400 {
                NotificationCenter.default.post(Notification(name: Notification.Name.tokenExpired))
                return
            }
            DispatchQueue.main.async {
                guard let content = try? JSONDecoder().decode(Content.self, from: data) else { return }
                self.content = content
                self.photos = []
                NotificationCenter.default.post(Notification(name: Notification.Name.contentWasObtained))
            }
        }
        task.resume()
    }
    
    func getPhoto(_ url: String) {
        print(url)
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.photos!.append(data)
            }
        }
        task.resume()
    }
    
    func getUserInfo() {
        let url = URL(string: "https://graph.instagram.com//me?fields=id,username&access_token=" + access_token)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            guard let data = data, error == nil, 
                  let userInfo = try? JSONDecoder().decode(Info.self, from: data) else { return }
            DispatchQueue.main.async {
                self.userInfo = userInfo
            }
        }
        task.resume()
    }
    
    func refreshToken() {
        let url = URL(string: "https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&&access_token=" + access_token)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            guard let data = data, error == nil,
                    let response = try? JSONDecoder().decode(LongLivedToken.self, from: data) else { return }
            DispatchQueue.main.async {
                self.access_token = response.access_token
                NotificationCenter.default.post(Notification(name: Notification.Name.tokenWasRefreshed))
            }
        }
        task.resume()
    }
}
