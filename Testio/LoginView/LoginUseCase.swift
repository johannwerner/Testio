import RxSwift
import Alamofire
import TOLogger
/// Login Use case
/// - Requires: `RxSwift`, `Alamofire`,  `TOLogger`
final class LoginUseCase {
    // MARK: Dependencies
    private let interactor: LoginInteractor
    
    // MARK: - Life cycle
    
    init(interactor: LoginInteractor) {
        self.interactor = interactor
    }
}

// MARK: - Public

extension LoginUseCase {
    func loginUser(input: LoginInputModel) -> Observable<LoginStatus> {
        interactor.loginUser(input: input)
            .map { (result: Async<Any>) -> LoginStatus in
                switch result {
                case .loading:
                    return .loading
                case .success(let data):
                    guard let responseModel = TokenModel.parse(from: data) else {
                        Logger.logError("responseModel is nil")
                        return .error(nil)
                    }
                    return .success(responseModel)
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
    }
    
    func fetchServers(input: TokenModel) -> Observable<ServerStatus> {
        interactor.fetchServers(input: input)
            .map { (result: Async<Any>) -> ServerStatus in
                switch result {
                case .loading:
                    return .loading
                case .success(let data):
                    guard let servers = [Server].parse(from: data) else {
                        Logger.logError("failed to parse servers from data")
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
