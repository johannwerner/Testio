import RxSwift
import RxAlamofire
///
/// - Requires: `RxSwift`, `RxAlamofire`
final class ServerListInteractorApi: ServerListInteractor {}

extension ServerListInteractorApi {
    func fetchServersFromCache() -> Observable<Async<Any>> {
        Observable.create { observer in
            ServerPersistentModel.shared.getServers { result in
                switch result {
                case .success(let servers):
                    observer.onNext(servers)
                    observer.onCompleted()
                case .error:
                    observer.onNext([])
                    observer.onCompleted()
                }
            }
        return Disposables.create()
        }
        .async()
    }
    
    func fetchServersFromApi(input: TokenModel) -> Observable<Async<Any>> {
        NetworkLayer.fetchServers(input: input)
    }
}
