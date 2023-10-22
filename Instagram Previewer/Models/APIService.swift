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
    
    var access_token = "IGQWROemJZAMk55RzhqejlSU08zcU1BT0xqSmxLV3JyaE9COU1DZAUo2OFpfNUtiY01NSWVTYTR0TndWZA1VLWjZAVRHNPa1lPZAUpWMUZATZA2I1TkJjdktlemdlQ2t1bERyRExBTTJiM2hmVjg4dwZDZD"
    
    func getContent() {
        let urlString = "https://graph.instagram.com/me/media?fields=id&access_token="
        let url = URL(string: urlString + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data, let content = try? JSONDecoder().decode(Content.self, from: data) else { return }
            //DispatchQueue.main.async {
                self.content = content
            //}
            for data in content.data {
                //DispatchQueue.main.async {
                    self.getMediaData(data.id)
             //   }
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
            guard let data = data, let photo = try? JSONDecoder().decode(MediaData.self, from: data) else {
                return }
                self.mediaData.append(photo)
                self.getPhoto(photo.media_url)
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
    
}
