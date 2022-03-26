import RxSwift
import RxAlamofire
///
/// - Requires: `RxSwift`, `RxAlamofire`
final class ServerListInteractorApi: ServerListInteractor {}

extension ServerListInteractorApi {
    func getServers() -> Observable<Async<Any>> {
        Observable.create { observer in
            ServerPersistentModel.shared.getServers { servers in
                let value = Observable.just(servers)
                observer.onNext(servers)
                observer.onCompleted()
            }
        return Disposables.create()
        }.async()
    }
}
