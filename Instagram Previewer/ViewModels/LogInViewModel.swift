//
//  LogInViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInViewModel {
    
    var delegate: LogInViewModelDelegate!
    private var model: LogInManager!
    private var apiService: APIService!
    private var tokenObserver: NSObjectProtocol!
    private var dataObserver: NSObjectProtocol!
    private var contentObserver: NSObjectProtocol!
    
    init() {
        model = LogInManager()
        apiService = APIService()
    }
    
    func getCodeFrom(_ url: String){
        let from = url.index(url.startIndex, offsetBy: "https://socialsizzle.herokuapp.com/auth/?code=".count)
        let to = url.lastIndex(of: "#")!
        let code = String(url[from..<to])
        getData(code)
    }
    
    func getData(_ code: String){
        tokenObserver = NotificationCenter.default.addObserver(forName: Notification.Name.accessTokenWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            self.apiService.access_token = self.model.longLivedToken.access_token
            self.apiService.getUserInfo()
            self.apiService.getContent()
            do {
                try KeychainManager.saveToken(token: self.model.longLivedToken.access_token.data(using: .utf8)!, account: "app")
            } catch {
                print("Keychain error: ", error)
            }
        })
        contentObserver = NotificationCenter.default.addObserver(forName: Notification.Name.contentWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            for media in self.apiService.content.data {
                self.apiService.getPhoto(media.media_url)
            }
        })
        dataObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            Saver.saveData(User(id: self.apiService.userInfo.id,
                                  username: self.apiService.userInfo.username,
                                  media: self.apiService.photos!))
            self.removeObservers()
            self.delegate.dismissViewController()
        })
        model.getAccessToken(for: code)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(tokenObserver!, name: Notification.Name.accessTokenWasObtained, object: nil)
        NotificationCenter.default.removeObserver(dataObserver!, name: Notification.Name.contentWasObtained, object: nil)
        NotificationCenter.default.removeObserver(dataObserver!, name: Notification.Name.dataWasObtained, object: nil)
    }
}

protocol LogInViewModelDelegate {
    func dismissViewController()
}
