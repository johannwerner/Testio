import Alamofire
import CoreGraphics
/// Operation status enum for  ServiceListView.
enum ServerListStatus {
    case loading
    case error(String?)
    case success([Server])
}

/// View effect enum for  ServiceListView.
enum ServerListEffect {
    case success
    case loading
    case error
}

/// View action enum for  ServiceListView.
enum ServerListViewAction {
    case logoutButtonPressed
    case sortByOriginal
    case sortByDistancePressed
    case sortByAlphabetPressed
}

struct ServerListModel {
    var servers: [Server]
    var token: String
    var sort: ServerListSort = .original
    var fetchFromCache: Bool
}

struct ServerConstants {
    private init () {}
    static let appName = "Testio."
    static let filterButtonImage = "union"
    static let logoutImage = "logout"
    static let appMargin: CGFloat = 16
}

enum ServerListSort {
    case distance
    case alphabetical
    case original
}
