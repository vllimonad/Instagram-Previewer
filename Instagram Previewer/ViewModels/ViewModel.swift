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
    private var saver: Saver!
    private var reader: Reader!
    var delegate: ViewModelDelegate!
    private var dataObserver: NSObjectProtocol!
    
    init() {
        apiService = APIService()
        saver = Saver()
        reader = Reader()
    }
    
    func getDataFromFile() {
        user = reader.readData()
        delegate.setUsername(self.user.username)
        delegate.reloadCollectionView()
    }
    
    func getDataFromServer() {
        do {
            let tokenData = try KeychainManager.getToken(account: "app")
            apiService.access_token = String(data: tokenData!, encoding: .utf8)!
            apiService.getUserInfo()
            apiService.getContent()
        } catch {
            print(error)
        }
        dataObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            self.user.media = self.apiService.photos!
            self.user.username = self.apiService.userInfo.username
            self.delegate.setUsername(self.user.username)
            self.delegate.reloadCollectionView()
            Saver().saveData(self.user)
        })
    }
    
    func logout() {
        File.removeFile(File.getURL())
    }
    
    func getNumberOfItems() -> Int {
        return user.media.count
    }
    
    func getItemAt(_ index: Int) -> UIImage {
        return UIImage(data: user.media[index])!
    }
    
    func getUserPicture() -> UIImage {
        guard let picture = apiService.userPicture else { return UIImage(systemName: "circle")!}
        return UIImage(data: picture)!
    }
    
    func removeItemAt(_ index: Int) -> Data {
        let item = user.media.remove(at: index)
        saver.saveData(user)
        return item
    }
    
    func insertItemAt(_ data: Data, _ index: Int) {
        user.media.insert(data, at: index)
        saver.saveData(user)
        delegate.reloadCollectionView()
    }
    
}

protocol ViewModelDelegate {
    func reloadCollectionView()
    func setUsername(_ username: String)
}
