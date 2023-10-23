//
//  APIService.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

final class APIService {
    
    var content: Content?
    var photos: [Data]?
    var userPicture: Data?
    
    let urlString = "https://graph.instagram.com/"
    var access_token = "IGQWRNZAUFvQ0FCMk5xSmlBeDRPMW5ORFpPbGZA3dUxWLUstY1hRRDhGMlFMSC1kVmtPcHFudThyWmkyc0NsLXZAkX0ItS1hiUDUzbzVQcHEzNV9QSWNIYllaYUM4YlVrVnhPR0luTFVxMGxNQQZDZD"
    
    func getContent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let url = URL(string: urlString + "/me/media?fields=media_url,timestamp&access_token=" + access_token)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.content = try? JSONDecoder().decode(Content.self, from: data)
                self.content?.data.sort(by: { dateFormatter.date(from:$0.timestamp)! > dateFormatter.date(from:$1.timestamp)!})
                self.photos = []
                for data in self.content!.data {
                    self.getPhoto(data.media_url)
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
        let urlfield = "/picture/"
        let urlRequest = URLRequest(url: URL(string: urlString + userID + urlfield)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            guard let data = data else { return }
            self.userPicture = data
        }
        task.resume()
    }    
}
