//
//  Saver.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class Saver {
    static func saveData(_ photos: User) {
        if let data = try? JSONEncoder().encode(photos) {
            try? data.write(to: File.getURL())
        }
    }
}

final class Reader {
    static func readData() -> User {
        if let data = try? Data(contentsOf: File.getURL()) {
            let user = try! JSONDecoder().decode(User.self, from: data)
            return user
        }
        return User(id: "", username: "", media: [])
    }
}

final class File {
    static func getURL() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appending(path: "PhotosData.txt")
    }
    
    static func removeFile(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
}
