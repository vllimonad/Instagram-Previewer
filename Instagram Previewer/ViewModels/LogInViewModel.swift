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
        //service.getUserPicture()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.service.mediaData.sort(by: { dateFormatter.date(from:$0.timestamp)! > dateFormatter.date(from:$1.timestamp)!})
            for data in self.service.mediaData {
                self.service.getPhoto(data.media_url)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.delegate.reload()
            }
        }
    }
    
    func getNumberOfItems() -> Int {
        return service.content == nil ? 0 : service.content!.data.count
    }
    
    func getItemAt(_ index: Int) -> UIImage {
        return UIImage(data: service.photos[index])!
    }
    
    func getUserPicture() -> UIImage {
        guard let picture = service.userPicture else { return UIImage(systemName: "circle")!}
        return UIImage(data: picture)!
    }
    
}

protocol LogInViewModelDelegate {
    func reload()
}
