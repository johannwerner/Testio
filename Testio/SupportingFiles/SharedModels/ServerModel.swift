import Foundation

enum ServerStatus {
    case loading
    case error(String?)
    case success([Server])
}

struct Server: Codable {
    var name: String?
    var distance: Int?
    
    /// distanceWrappedMax gives the value of distance or if nil gives Int Max value
    var distanceWrappedMax: Int {
        distance ?? Int.max
    }
}
