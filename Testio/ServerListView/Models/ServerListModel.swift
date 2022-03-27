import Alamofire
/// Operation status enum for  ServiceListView.
enum ServerListStatus {
    case loading
    case error
    case success
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
    case sortByDistancePressed
    case sortByAlphabetPressed
}

struct ServerListModel {
    var servers: [Server]
    var token: String
    var sort: ServerListSort = .distance
    var fetchFromCache: Bool
}

struct ServerConstants {
    private init () {}
    static let appName = "Testio."
    static let filterButtonImage = "union"
    static let logoutImage = "logout"
}

enum ServerListSort {
    case distance
    case alphabetical
}
