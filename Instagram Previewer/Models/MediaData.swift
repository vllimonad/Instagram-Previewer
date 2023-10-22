//
//  MediaData.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

struct Content: Codable {
    let data: [Media]
    let paging: Paging
}

struct Media: Codable {
    let id: String
}

struct Paging: Codable {
    let cursors: Cursors
}

struct Cursors: Codable {
    let before: String
    let after: String
}

struct MediaData: Codable {
    let id: String
    let media_type: String
    let media_url: String
    let username: String
    let timestamp: String
}
