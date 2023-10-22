//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

class APIService {
    
    var content: Content?
    var mediaData: [MediaData] = []
    var photos: [Data] = []
    var userPicture: Data?
    
    var access_token = "IGQWROVUlLVlc5TTh3VkhzdzlwWDN5MThETzhySXhXZAVlwN3AwOWw5OEhlNXVYQXM4aElyakI0ZAlM1MElEVGx1U1UtMG50ZATdDZAHNIeThRQWM1eEY4OWtsWGIxckdNUnJNRGNpaXlYTnB3bm1hWmpNX3FBSUFoTUlRXzBPa2dxMUo5QQZDZD"
    
    func getContent() {
        let urlString = "https://graph.instagram.com/me/media?fields=id&access_token="
        let url = URL(string: urlString + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let content = try? JSONDecoder().decode(Content.self, from: data) else { return }
            self.content = content
            for data in content.data {
                self.getMediaData(data.id)
            }
        }
        task.resume()
    }
    
    func getMediaData(_ mediaID: String) {
        let urlString = "https://graph.instagram.com/"
        let urlFields = "?fields=id,media_type,media_url,username,timestamp&access_token="
        let url = URL(string: urlString + mediaID + urlFields + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let photo = try? JSONDecoder().decode(MediaData.self, from: data) else { return }
            self.mediaData.append(photo)
            print(photo.media_url)
        }
        task.resume()
    }
    
    func getPhoto(_ urlString: String) {
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else { return }
            self.photos.append(data)
        }
        task.resume()
    }
    
    func getUserPicture() {
        let urlString = "https://graph.instagram.com/"
        let userID = "6523499164443487"
        let urlfield = "/picture"
        let urlRequest = URLRequest(url: URL(string: urlString + userID + urlfield)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else { return }
            self.userPicture = data
            print(data)
        }
        task.resume()
    }
    
}
