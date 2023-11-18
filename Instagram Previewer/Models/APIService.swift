//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

final class APIService {
    
    var userInfo: Info!
    var access_token: String!
    var content: Content?
    var photos: [Data]? {
        didSet {
            if self.photos?.count == self.content?.data.count {
                NotificationCenter.default.post(Notification(name: Notification.Name.dataWasObtained))
            }
        }
    }
    
    func getContent() {
        let url = URL(string: "https://graph.instagram.com//me/media?fields=media_url,timestamp&access_token=" + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.content = try? JSONDecoder().decode(Content.self, from: data)
                self.photos = []
                for media in self.content!.data {
                    self.getPhoto(media.media_url)
                }
            }
        }
        task.resume()
    }
    
    func getPhoto(_ url: String) {
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
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.userInfo = try! JSONDecoder().decode(Info.self, from: data)
            }
        }
        task.resume()
    }
}
