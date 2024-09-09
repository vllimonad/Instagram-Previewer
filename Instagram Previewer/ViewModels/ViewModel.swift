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
    
    private var apiService: APIService!
    private var user: User!
    var delegate: ViewModelDelegate!
    
    init() {
        apiService = APIService()
    }
    
    func getDataFromFile() {
        user = DataManager.shared.readData()
        delegate.setUsername(self.user.username)
        delegate.reloadCollectionView()
    }
    
    func getDataFromServer() {
        do {
            let tokenData = try KeychainManager.shared.getToken(account: "app")
            apiService.access_token = String(data: tokenData!, encoding: .utf8)!
            apiService.getUserInfo()
            apiService.getContent()
        } catch { print(error) }
        NotificationCenter.default.addObserver(forName: Notification.Name.contentWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            for media in self.apiService.content.data {
                if media.media_type == "IMAGE"{
                    self.apiService.getPhoto(media.media_url)
                } else {
                    let asset = AVAsset(url: URL(string: media.media_url)!)
                    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
                    let time = CMTimeMakeWithSeconds(0.1, preferredTimescale: 600)
                    if let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) {
                         UIImage(cgImage: img).jpegData(compressionQuality: 0.8)
                    }
                }
            }
        })
        NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            self.user.media = self.apiService.photos!
            self.user.username = self.apiService.userInfo.username
            self.delegate.setUsername(self.user.username)
            self.delegate.reloadCollectionView()
            DataManager.shared.saveData(self.user)
        })
        NotificationCenter.default.addObserver(forName: Notification.Name.tokenExpired, object: nil, queue: OperationQueue.main, using: { _ in
            self.apiService.refreshToken()
        })
        NotificationCenter.default.addObserver(forName: Notification.Name.tokenWasRefreshed, object: nil, queue: OperationQueue.main, using: { _ in
            do {
                try KeychainManager.shared.saveToken(token: self.apiService.access_token.data(using: .utf8)!, account: "app")
                self.apiService.getUserInfo()
                self.apiService.getContent()
            } catch { print("Keychain error: ", error) }
        })
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
