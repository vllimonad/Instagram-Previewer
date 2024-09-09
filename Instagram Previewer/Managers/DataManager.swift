//
//  DataManager.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 09/09/2024.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: "PhotosData.txt")
    }
    
    private init() {}
    
    func saveData(_ photos: User) {
        if let data = try? JSONEncoder().encode(photos) {
            try? data.write(to: url)
        }
    }
    
    func readData() -> User {
        if let data = try? Data(contentsOf: url) {
            let user = try! JSONDecoder().decode(User.self, from: data)
            return user
        }
        return User(id: "", username: "", media: [])
    }
    
    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    func getURL() -> URL {
        return url
    }
}
