//
//  LogInViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInViewModel {
    
    var delegate: LogInViewModelDelegate!
    var longLivedAccessToken: LongLivedToken! {
        didSet {
            saveToken()
            getData()
        }
    }
    var user: User!
    var content: Content! {
        didSet {
            getPhotos()
        }
    }
    
    func getCodeFrom(_ url: String) -> String {
        let from = url.index(url.startIndex, offsetBy: "https://socialsizzle.herokuapp.com/auth/?code=".count)
        let to = url.lastIndex(of: "#")!
        let code = String(url[from..<to])
        return code
    }
    
    func getToken(_ code: String) {
        AccessTokenManager.shared.getAccessToken(for: code) { result in
            switch result {
            case .success(let token):
                AccessTokenManager.shared.getLongLivedAccessToken(for: token) { result in
                    switch result {
                    case .success(let longLivedToken):
                        self.longLivedAccessToken = longLivedToken
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getData() {
        APIService.shared.getUserInfo(with: self.longLivedAccessToken.access_token) { result in
            switch result {
            case .success(let userInfo):
                APIService.shared.getContent(with: self.longLivedAccessToken.access_token) { result in
                    switch result {
                    case .success(let content):
                        self.content = content
                        self.user = User(id: userInfo.id,
                                    username: userInfo.username,
                                    media: [])
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPhotos() {
        var photos: [Data] = []
        for media in content.data {
            APIService.shared.getPhoto(media.media_url) { result2 in
                switch result2 {
                case .success(let data):
                    photos.append(data)
                    if photos.count == self.content.data.count - 1 {
                        self.user.media = photos
                        DataManager.shared.saveData(self.user)
                        DispatchQueue.main.sync {
                            self.delegate.dismissViewController()
                        }
                    }
                case .failure(let error2):
                    print(error2)
                }
            }
        }
    }
    
    func saveToken() {
        do {
            try KeychainManager.shared.saveToken(token: self.longLivedAccessToken.access_token.data(using: .utf8)!, account: "app")
        } catch {
            print("Keychain error: ", error)
        }
    }
}

protocol LogInViewModelDelegate {
    func dismissViewController()
}
