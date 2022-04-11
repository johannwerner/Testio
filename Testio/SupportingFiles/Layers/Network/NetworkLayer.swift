import RxSwift
import RxAlamofire

final class NetworkLayer {
    private init () {}
    static func fetchServers(input: TokenModel) -> Observable<Async<Any>> {
        RxAlamofire
            .requestJSON(
                .get,
                serverUrl,
                headers: input.headers
            )
            .flatMap { _, json -> Observable<Any> in
                Observable.just(json)
            }
            .async()
    }
    
    static func loginUser(input: LoginInputModel) -> Observable<Async<Any>> {
        RxAlamofire
            .requestJSON(
                .post,
                loginUrl,
                parameters: input.parameters
            )
            .flatMap { _, json -> Observable<Any> in
                Observable.just(json)
            }
            .async()
    }
}


private extension NetworkLayer {
    static var loginUrl: String {
        "https://playground.nordsec.com/v1/tokens"
    }
    
    static var serverUrl: String {
        "https://playground.nordsec.com/v1/servers"
    }
}
