import Foundation
import TOLogger

// MARK: Decodable

public extension Decodable {
    static func parse(from item: Any?, strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> Self? {
        guard let data = data(from: item) else {
            Logger.logWarning("data is nil")
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        
        do {
            let result = try decoder.decode(Self.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
    private static func data(from item: Any?) -> Data? {
        switch item {
        case let data as Data:
            return data
        case let string as String:
            return string.data(using: .utf8)
        case .some(let item):
            return try? JSONSerialization.data(withJSONObject: item, options: [])
        case nil:
            return nil
        }
    }
}
