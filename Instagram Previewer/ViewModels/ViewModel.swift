//
//  LoginViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation
import UIKit

final class ViewModel {
    
    private var service: APIService!
    private var saver: Saver!
    private var reader: Reader!
    var delegate: ViewModelDelegate!
    var dataObserver: NSObjectProtocol!
    
    init() {
        service = APIService()
        saver = Saver()
        reader = Reader()
    }
    
    func getDataFromFile() {
        service.photos = reader.readData()
        delegate.reloadCollectionView()
    }
    
    func getDataFromServer() {
        let token = try? KeychainManager.getToken(account: "1")
        service.access_token = String(data: token!, encoding: .utf8)!
        service.getContent()
        dataObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataWasObtained, object: nil, queue: OperationQueue.main, using: { _ in
            Saver().saveData(self.service.photos!)
            self.delegate.reloadCollectionView()
        })
    }
    
    func getNumberOfItems() -> Int {
        return service.photos == nil ? 0 : service.photos!.count
    }
    
    func getItemAt(_ index: Int) -> UIImage {
        return UIImage(data: service.photos![index])!
    }
    
    func getUserPicture() -> UIImage {
        guard let picture = service.userPicture else { return UIImage(systemName: "circle")!}
        return UIImage(data: picture)!
    }
    
    func removeItemAt(_ index: Int) -> Data {
        let item = service.photos?.remove(at: index)
        saver.saveData(service.photos!)
        return item!
    }
    
    func insertItemAt(_ data: Data, _ index: Int) {
        service.photos?.insert(data, at: index)
        saver.saveData(service.photos!)
        delegate.reloadCollectionView()
    }
    
}

protocol ViewModelDelegate {
    func reloadCollectionView()
}
