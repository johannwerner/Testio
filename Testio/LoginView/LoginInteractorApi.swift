import RxSwift
import RxAlamofire
///
/// - Requires: `RxSwift`, `RxAlamofire`
final class LoginInteractorApi: LoginInteractor {}

extension LoginInteractorApi {
    // MARK: - Internal
    
    func loginUser(input: LoginInputModel) -> Observable<Async<Any>> {
        NetworkLayer.loginUser(input: input)
    }
    
    func fetchServers(input: TokenModel) -> Observable<Async<Any>> {
        NetworkLayer.fetchServers(input: input)
    }
}
