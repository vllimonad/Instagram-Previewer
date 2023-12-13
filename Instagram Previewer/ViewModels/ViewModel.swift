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
        user = Reader.readData()
        delegate.setUsername(self.user.username)
        delegate.reloadCollectionView()
    }
    
    func getDataFromServer() {
        do {
            let tokenData = try KeychainManager.getToken(account: "app")
            apiService.access_token = String(data: tokenData!, encoding: .utf8)!
            apiService.getUserInfo()
            apiService.getContent()
        } catch { print(error) }
        NotificationCenter.default.addObserver(forName: Notification.Name.contentWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            for media in self.apiService.content.data {
                self.apiService.getPhoto(media.media_url)
            }
        })
        NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            self.user.media = self.apiService.photos!
            self.user.username = self.apiService.userInfo.username
            self.delegate.setUsername(self.user.username)
            self.delegate.reloadCollectionView()
            Saver.saveData(self.user)
        })
        NotificationCenter.default.addObserver(forName: Notification.Name.tokenExpired, object: nil, queue: OperationQueue.main, using: { _ in
            self.apiService.refreshToken()
        })
        NotificationCenter.default.addObserver(forName: Notification.Name.tokenWasRefreshed, object: nil, queue: OperationQueue.main, using: { _ in
            do {
                try KeychainManager.saveToken(token: self.apiService.access_token.data(using: .utf8)!, account: "app")
                self.apiService.getUserInfo()
                self.apiService.getContent()
            } catch { print("Keychain error: ", error) }
        })
    }
    
    func logout() {
        File.removeFile(File.getURL())
    }
    
    func getNumberOfItems() -> Int {
        return user.media.count
    }
    
    func getItemAt(_ index: Int) throws -> UIImage {
        if index == 0 {
            let asset = AVAsset(url: URL(string: "https://scontent.cdninstagram.com/o1/v/t16/f1/m82/3949BDB65F544D2F4F45B5B963F2B593_video_dashinit.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLmNsaXBzLnVua25vd24tQzMuNzIwLmRhc2hfYmFzZWxpbmVfMV92MSJ9&_nc_ht=scontent.cdninstagram.com&_nc_cat=104&vs=378062901383563_1224009302&_nc_vs=HBksFQIYT2lnX3hwdl9yZWVsc19wZXJtYW5lbnRfcHJvZC8zOTQ5QkRCNjVGNTQ0RDJGNEY0NUI1Qjk2M0YyQjU5M192aWRlb19kYXNoaW5pdC5tcDQVAALIAQAVAhg6cGFzc3Rocm91Z2hfZXZlcnN0b3JlL0dGd0ZReGh2a0RQdXkzTUdBSWU1Yk9hOVJHSTRicV9FQUFBRhUCAsgBACgAGAAbAYgHdXNlX29pbAExFQAAJsj7r4z2u5BAFQIoAkMzLBdAETMzMzMzMxgSZGFzaF9iYXNlbGluZV8xX3YxEQB1AAA%3D&ccb=9-4&oh=00_AfCv3KdiiGK9EfS0SELgQoVG2cX37WWImuq0IGwJtf9jfg&oe=657BD5C7&_nc_sid=1d576d&_nc_rid=1711335ddf")!)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
                                    assetImageGenerator.appliesPreferredTrackTransform = true
                                    assetImageGenerator.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
            let cmTime = CMTime(seconds: TimeInterval.pi, preferredTimescale: 60)
            let thumbnailImage = try assetImageGenerator.image(at: cmTime).image
            return UIImage(cgImage: thumbnailImage)
        }
        return UIImage(data: user.media[index])!
    }
    
    func removeItemAt(_ index: Int) -> Data {
        let item = user.media.remove(at: index)
        Saver.saveData(user)
        return item
    }
    
    func insertItemAt(_ data: Data, _ index: Int) {
        user.media.insert(data, at: index)
        Saver.saveData(user)
        delegate.reloadCollectionView()
    }
    
}

protocol ViewModelDelegate {
    func reloadCollectionView()
    func setUsername(_ username: String)
}
