import RxSwift
import RxAlamofire
///
/// - Requires: `RxSwift`, `RxAlamofire`
final class LoginInteractorApi: LoginInteractor {}

extension LoginInteractorApi {
    // MARK: - Internal
    
    func loginUser(input: LoginInputModel) -> Observable<Async<Any>> {
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
    
    func getServers(input: TokenModel) -> Observable<Async<Any>> {
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
}

private extension LoginInteractorApi {
    var loginUrl: String {
        "https://playground.nordsec.com/v1/tokens"
    }
    
    var serverUrl: String {
        "https://playground.nordsec.com/v1/servers"
    }
}
