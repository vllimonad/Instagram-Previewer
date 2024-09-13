//
//  LoginViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation
import UIKit
import AVFoundation
import AssetsLibrary

final class ViewModel {
    
    private var user: User!
    var delegate: ViewModelDelegate!
    
    func getDataFromFile() {
        user = DataManager.shared.readData()
        delegate.setUsername(self.user.username)
        delegate.reloadCollectionView()
    }
    
    func getDataFromServer() {
        do {
            let tokenData = try KeychainManager.shared.getToken(account: "app")
            let token = String(data: tokenData!, encoding: .utf8)!
            APIService.shared.getUserInfo(with: token) { result in
                switch result {
                case .success(let userInfo):
                    self.user.username = userInfo.username
                    APIService.shared.getContent(with: token) { result in
                        switch result {
                        case .success(let content):
                            self.getPhotos(from: content)
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getPhotos(from content: Content) {
        var photos: [Data] = []
        for media in content.data {
            APIService.shared.getPhoto(media.media_url) { result in
                switch result {
                case .success(let data):
                    photos.append(data)
                    if photos.count == content.data.count - 1 {
                        DispatchQueue.main.sync {
                            self.user.media = photos
                            self.delegate.setUsername(self.user.username)
                            self.delegate.reloadCollectionView()
                            DataManager.shared.saveData(self.user)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func logout() {
        DataManager.shared.deleteFile()
    }
    
    func getNumberOfItems() -> Int {
        return user.media.count
    }
    
    func getItemAt(_ index: Int) -> UIImage {
        return UIImage(data: user.media[index])!
    }
    
    func removeItemAt(_ index: Int) -> Data {
        let item = user.media.remove(at: index)
        DataManager.shared.saveData(user)
        return item
    }
    
    func insertItemAt(_ data: Data, _ index: Int) {
        user.media.insert(data, at: index)
        DataManager.shared.saveData(user)
        delegate.reloadCollectionView()
    }
    
}

protocol ViewModelDelegate {
    func reloadCollectionView()
    func setUsername(_ username: String)
}
