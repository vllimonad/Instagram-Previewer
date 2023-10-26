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
    
    init() {
        service = APIService()
        saver = Saver()
        reader = Reader()
    }
    
    func getDataFromFile() {
        service.photos = reader.readData()
        delegate.reload()
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
    }
    
}

protocol ViewModelDelegate {
    func reload()
}
