//
//  KeyChainProviderToken.swift
//  Testio
//
//  Created by Johann Werner on 26.03.22.
//

import Foundation

struct TokenCredentials {
    var username: String
    var token: String
}

extension KeychainProvider {
    static let serviceTypeToken = "logintoken"
    
    static func storeGenericToken(credentials: TokenCredentials) throws {
        if credentials.token.isEmpty {
            try deleteToken(username: credentials.username)
            return
        }
        guard let tokenData = credentials.token.data(using: .utf8) else {
            throw KeychainError.unexpectedError
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username,
            kSecAttrService as String: serviceTypeToken,
            kSecValueData as String: tokenData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            try updateGenericTokenFor(
                credentials: credentials
                )
        default:
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func getGeneriTokenFor(username: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceTypeToken,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard let existingItem = item as? [String: Any] else {
            throw KeychainError.unexpectedError
        }
        
        guard let valueData = existingItem[kSecValueData as String] as? Data else {
            throw KeychainError.unexpectedError
        }
        guard let value = String(data: valueData, encoding: .utf8) else {
            throw KeychainError.unexpectedError
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        return value
    }
    
    static func updateGenericTokenFor(
        credentials: TokenCredentials
    ) throws {
        guard let tokenData = credentials.token.data(using: .utf8) else {
            return
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username,
            kSecAttrService as String: serviceTypeToken
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: tokenData
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func deleteToken(username: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceTypeToken
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        guard status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
