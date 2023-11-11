//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

final class APIService {
    
    var content: Content?
    var photos: [Data]? {
        didSet {
            if self.photos?.count == self.content?.data.count {
                NotificationCenter.default.post(Notification(name: Notification.Name.dataWasObtained))
            }
        }
    }
    var userPicture: Data?
    let urlString = "https://graph.instagram.com/"
    var access_token = ""
    
    func getContent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let url = URL(string: urlString + "/me/media?fields=media_url,timestamp&access_token=" + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    self.content = try JSONDecoder().decode(Content.self, from: data)
                    self.content?.data.sort(by: { dateFormatter.date(from:$0.timestamp)! > dateFormatter.date(from:$1.timestamp)!})
                    self.photos = []
                    for media in self.content!.data {
                        self.getPhoto(media.media_url)
                    }
                } catch {
                    print(error)
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
    
    func getUserPicture() {
        let userID = "6523499164443487"
        let req = "https://graph.instagram.com/me?fields=id,username,profile_pic&access_token="
        //let urlRequest = URLRequest(url: URL(string: urlString + userID + urlfield)!)
        let urlRequest = URLRequest(url: URL(string: req + access_token)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let user = try? JSONDecoder().decode(User.self, from: data) else { return }
            self.userPicture = data
            print(user.user_id)
            //print(user.profile_pic)
        }
        task.resume()
    }
}
