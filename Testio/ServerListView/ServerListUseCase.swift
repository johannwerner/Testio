import RxSwift
import TOLogger
/// Server Use case
/// - Requires: `RxSwift`, `TOLogger`
final class ServerListUseCase {
    // MARK: Dependencies
    private let interactor: ServerListInteractor
    
    // MARK: - Life cycle
    
    init(interactor: ServerListInteractor) {
        self.interactor = interactor
    }
}

// MARK: - Public

extension ServerListUseCase {
    func fetchServersFromCache() -> Observable<ServerListStatus> {
        interactor.fetchServersFromCache()
            .map { (result: Async<Any>) -> ServerListStatus in
                switch result {
                case .loading:
                    return .loading
                case .success(let data):
                    guard let servers = data as? [Server] else {
                        Logger.logError("data is not of type [Server]")
                        return .error(nil)
                    }
                    let serversSorted = servers.filter { $0.name != nil && $0.distance != nil }
                    return .success(serversSorted)
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
    }
    
    func fetchServersFromApi(input: TokenModel) -> Observable<ServerListStatus> {
        interactor.fetchServersFromApi(input: input)
            .map { (result: Async<Any>) -> ServerListStatus in
                switch result {
                case .loading:
                    return .loading
                case .success(let data):
                    guard let servers = [Server].parse(from: data) else {
                        Logger.logError("failed to parse data json")
                        return .error(nil)
                    }
                    let serversSorted = servers.filter { $0.name != nil && $0.distance != nil }
                    ServerPersistentModel.shared.deleteAllServers()
                    for server in serversSorted {
                        ServerPersistentModel.shared.save(server: server)
                    }
                    return .success(serversSorted)
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
    }
}
