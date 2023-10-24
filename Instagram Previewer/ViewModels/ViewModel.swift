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
    var delegate: LogInViewModelDelegate!
    
    /*func getDataFromServer() {
        service = APIService()
        service.getContent()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            self.delegate.reload()
        }
    }*/
    
    func getDataFromFile() {
        service = APIService()
        saver = Saver()
        service.photos = saver.readData()
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
    
}

protocol LogInViewModelDelegate {
    func reload()
}
