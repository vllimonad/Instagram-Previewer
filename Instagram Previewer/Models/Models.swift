//
//  MediaData.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

struct Content: Codable {
    var data: [Media]
    let paging: Paging
    
    struct Paging: Codable {
        let cursors: Cursors
        
        struct Cursors: Codable {
            let before: String
            let after: String
        }
    }
}

struct Media: Codable {
    let media_url: String
    let timestamp: String
}

struct User: Codable {
    let access_token: String
    let user_id: Int
}

struct LongLivedToken: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}