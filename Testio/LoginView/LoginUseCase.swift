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
                        return .error
                    }
                    return .success(responseModel)
                case .error:
                    return .error
                }
            }
    }
    
    func getServers(input: TokenModel) -> Observable<ServerStatus> {
        interactor.getServers(input: input)
            .map { (result: Async<Any>) -> ServerStatus in
                switch result {
                case .loading:
                    return .loading
                case .success(let data):
                    guard let responseModel = [Server].parse(from: data) else {
                        return .error
                    }
                    return .success(responseModel)
                case .error:
                    return .error
                }
            }
    }
}
