//
//  LoginViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation
import UIKit

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
    
    func getItemAt(_ index: Int) -> UIImage {
        if index == 0 {
            return UIImage()
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
