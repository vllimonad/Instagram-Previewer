//
//  User.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 09/09/2024.
//

import Foundation

struct User: Codable {
    let id: String
    var username: String
    var media: [Data]
}
