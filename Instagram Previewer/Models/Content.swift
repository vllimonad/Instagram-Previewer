//
//  Content.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 09/09/2024.
//

import Foundation

struct Content: Codable {
    var data: [Media]
    var paging: Paging
    
    struct Paging: Codable {
        let cursors: Cursors
        
        struct Cursors: Codable {
            let before: String
            let after: String
        }
    }
}
