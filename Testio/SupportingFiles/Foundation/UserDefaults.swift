//
//  UserDefaultsProperty.swift
//  Testio
//
//  Created by Johann Werner on 25.03.22.
//

import Foundation
import UIKit

@propertyWrapper
public struct UserDefaultsProperty<X: Codable> {
    private let userDefaultsKey: String
    private let initalValue: X

    public init(userDefaultsKey: String, initalValue: X) {
        self.userDefaultsKey = userDefaultsKey
        self.initalValue = initalValue
    }

    public var wrappedValue: X {
        get {
            guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {
                if let value = UserDefaults.standard.object(forKey: userDefaultsKey) as? X {
                    return value
                }
                return initalValue
            }
            guard let value = try? JSONDecoder().decode(X.self, from: data) else {
                return initalValue
            }
            return value
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                return
            }
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

struct UserDefaultsUtils {
    private init() {}
    @UserDefaultsProperty(userDefaultsKey: "username", initalValue: nil)
    public static var username: String?
}
