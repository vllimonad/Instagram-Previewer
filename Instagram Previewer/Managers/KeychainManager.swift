//
//  KeychainManager.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 30/10/2023.
//

import Foundation

enum KeychainError: Error {
    case duplicatedToken
    case unknown(OSStatus)
}

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    func saveToken(token: Data, account: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecValueData: token
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicatedToken
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func getToken(account: String) throws -> Data? {
        let query: [CFString : Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        return result as? Data
    }
}
