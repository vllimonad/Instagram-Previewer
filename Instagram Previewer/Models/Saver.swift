//
//  Saver.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

class Saver {
    
    func readData() -> [Data] {
        if let data = try? Data(contentsOf: getURL()) {
            let photos = try! JSONDecoder().decode([Data].self, from: data)
            return photos
        }
        return []
    }
    
    func saveData(_ photos: [Data]) {
        if let data = try? JSONEncoder().encode(photos) {
            try? data.write(to: getURL())
        }
    }
    
    func getURL() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appending(path: "PhotosData.txt")
    }
}
