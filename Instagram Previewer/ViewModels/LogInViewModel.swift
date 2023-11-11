//
//  LogInViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInViewModel {
    
    var delegate: LogInViewModelDelegate!
    var model: LogInModel!
    var apiService: APIService!
    var tokenObserver: NSObjectProtocol!
    var dataObserver: NSObjectProtocol!
    
    init() {
        model = LogInModel()
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
                print(error)
            }
        })
        dataObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            Saver().saveData(User(id: self.apiService.userInfo.id,
                                  username: self.apiService.userInfo.username,
                                  media: self.apiService.photos!))
            self.delegate.dismissViewController()
        })
        model.getAccessToken(for: code)
    }
}

protocol LogInViewModelDelegate {
    func dismissViewController()
}
