//
//  LoginViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation
import UIKit

final class LogInViewModel {
    
    private var service: APIService!
    var delegate: LogInViewModelDelegate!
    
    func getUserData() {
        service = APIService()
        service.getContent()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.51) {
            self.delegate.reload()
        }
    }
    
    func getNumberOfItems() -> Int {
        return service.content == nil ? 0 : service.content!.data.count
    }
    
    func getItemAt(_ index: Int) -> UIImage {
        return UIImage(data: service.photos[index])!
    }
    
}

protocol LogInViewModelDelegate {
    func reload()
}
