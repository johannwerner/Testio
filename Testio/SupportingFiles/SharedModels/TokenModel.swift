import Alamofire
import Foundation

struct TokenModel: Codable {
    var token: String

    var headers: HTTPHeaders {
        HTTPHeaders(arrayLiteral: HTTPHeader(name: "Authorization", value: "Bearer \(token)"))
    }
}
