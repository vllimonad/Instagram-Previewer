//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

final class APIService {
    
    let instagramURL = "https://graph.instagram.com/"
    var userInfo: Info!
    var userPicture: Data?
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
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .full
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let url = URL(string: instagramURL + "/me/media?fields=media_url,timestamp&access_token=" + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.content = try? JSONDecoder().decode(Content.self, from: data)
                //self.content?.data.sort(by: { dateFormatter.date(from:$0.timestamp)! > dateFormatter.date(from:$1.timestamp)!})
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
        let url = URL(string: instagramURL + "/me?fields=id,username&access_token=" + access_token)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.userInfo = try! JSONDecoder().decode(Info.self, from: data)
            }
        }
        task.resume()
    }
    
    
    /*func getfulldata() {
        let url = URL(string: "https://www.instagram.com/sw.app1/?__a=1&__d=1")!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,_,error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    let d = try JSONDecoder().decode(Welcome10.self, from: data)
                    print("URL: \(d.graphql.user.profilePicURLHD)")
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }*/
    
    
    
    /*func getUserPicture() {
        //let userID = "6523499164443487"
        //let req = "https://graph.instagram.com/me?fields=id,username,profile_pic&access_token="
        //let urlRequest = URLRequest(url: URL(string: urlString + userID + urlfield)!)
        print("GETTING")
        let urlRequest = URLRequest(url: URL(string: "https://www.instagram.com/sw.app1/?__a=1&__d=1")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else {
                print("be")
                return }
            do {
                let user = try JSONDecoder().decode(Welcome.self, from: data)
                let s = user.graphql.user.profilePicURL
                print(s)
            } catch {
                print(error)
            }
        }
        task.resume()
    }*/
}
