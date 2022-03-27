import RxSwift
import Alamofire
/// Login Use case
/// - Requires: `RxSwift`, `Alamofire`
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
                        return .error(nil)
                    }
                    ServerPersistentModel.shared.deleteAllServers()
                    for server in servers {
                        ServerPersistentModel.shared.save(server: server)
                    }
                    return .success(servers)
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
    }
}
