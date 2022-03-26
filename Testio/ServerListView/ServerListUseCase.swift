import RxSwift
/// Server Use case
/// - Requires: RxSwift
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
    func getServers() -> Observable<ServerStatus> {
        interactor.getServers()
            .map { (result: Async<Any>) -> ServerStatus in
                switch result {
                case .loading:
                    return .loading
                case .success(let data):
                    print(data)
                    guard let servers = data as? [Server] else {
                        return .error(nil)
                    }
                    let serversSorted = servers.filter { $0.name != nil && $0.distance != nil }
                    return .success(serversSorted)
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
    }
}
