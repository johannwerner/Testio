// This class was created by taking inspiration from https://www.raywenderlich.com/11496196-how-to-secure-ios-user-data-keychain-services-and-biometrics-with-swiftui and
// https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain

import Foundation

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedError
    case unexpectedStatus(OSStatus)
    case tokenNotValid
}

struct Credentials {
    var username: String
    var token: String
}

final class KeychainProvider {
    private init() {}
    static let serviceTypeBiometrics = "biometricslogin"
    static let serviceTypeLoginToken = "logintoken"
    static func storeGenericTokenFor(credentials: Credentials, serviceType: String) throws {
        if credentials.token.isEmpty {
            try deletToken(username: credentials.username, serviceType: serviceType)
            return
        }
        guard let passwordData = credentials.token.data(using: .utf8) else {
            throw KeychainError.unexpectedError
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username,
            kSecAttrService as String: serviceType,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            try updateGenericTokenFor(
                credentials: credentials,
                serviceType: serviceType
                )
        default:
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func getGenericTokenFor(username: String, serviceType: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceType,
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
        credentials: Credentials,
        serviceType: String
    ) throws {
        guard let passwordData = credentials.token.data(using: .utf8) else {
            return
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username,
            kSecAttrService as String: serviceType
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func deletToken(username: String, serviceType: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceType
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
