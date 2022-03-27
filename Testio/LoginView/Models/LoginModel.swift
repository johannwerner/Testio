import Alamofire
import CoreGraphics
/// Operation status enum for  LoginView.
enum LoginStatus {
    case loading
    case error(String?)
    case success(TokenModel)
}

/// View effect enum for  LoginView.
enum LoginViewEffect {
    case success
    case loading
    case error(String?)
}

/// View action enum for  LoginView.
enum LoginViewAction {
    case loginButtonPressed(input: LoginInputModel)
}

struct LoginConstants {
    private init () {}
    static let loginBottomImage = "unsplash"
    static let loginLogo = "logo"
    static let usernameIconImage = "symbol"
    static let passwordIconImage = "security"
    static let appMargin: CGFloat = 32
    static let cornerRadius: CGFloat = 10
}

struct LoginInputModel {
    var username: String?
    var password: String?
    
    var parameters: [String: Any] {
        [
            "username": username ?? "",
            "password": password ?? ""
        ]
    }
    
    var isValidInput: Bool {
        guard let username = username else {
            return false
        }
        guard let password = password else {
            return false
        }
        return !username.isEmpty && !password.isEmpty
    }
}

struct TokenModel: Codable {
    var token: String

    var headers: HTTPHeaders {
        HTTPHeaders(arrayLiteral: HTTPHeader(name: "Authorization", value: "Bearer \(token)"))
    }
}
