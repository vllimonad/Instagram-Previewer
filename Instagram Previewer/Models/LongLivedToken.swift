//
//  LongLivedToken.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 09/09/2024.
//

import Foundation

struct LongLivedToken: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}
