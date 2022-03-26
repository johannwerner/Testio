import RxSwift
import RxAlamofire
///
/// - Requires: `RxSwift`, `RxAlamofire`
final class ServerListInteractorApi: ServerListInteractor {}

extension ServerListInteractorApi {
    func getServersFromCache() -> Observable<Async<Any>> {
        Observable.create { observer in
            ServerPersistentModel.shared.getServers { servers in
                observer.onNext(servers)
                observer.onCompleted()
            }
        return Disposables.create()
        }
        .async()
    }
    
    func getServersFromApi(input: TokenModel) -> Observable<Async<Any>> {
        RxAlamofire
            .requestJSON(
                .get,
                AppConstants.serverUrl,
                headers: input.headers
            )
            .flatMap { _, json -> Observable<Any> in
                Observable.just(json)
            }
            .async()
    }
}
