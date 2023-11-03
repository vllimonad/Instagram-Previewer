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
            self.apiService.access_token = self.model.user.access_token
            self.apiService.getContent()
            try? KeychainManager.saveToken(token: self.apiService.access_token.data(using: .utf8)!, account: "1")
        })
        dataObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            Saver().saveData(self.apiService.photos!)
            self.delegate.dismissViewController()
        })
        model.getAccessToken(for: code)
    }
}

protocol LogInViewModelDelegate {
    func dismissViewController()
}
