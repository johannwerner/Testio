import RxCocoa
import RxSwift

///
/// - Requires: `RxSwift`, `RxCocoa`
/// - Note: A view model can refer to one or more use cases.

final class LoginViewModel {
    // MARK: ViewEffect
    let viewEffect = PublishRelay< LoginViewEffect>()
    
    // MARK: Dependencies
    private let coordinator: LoginCoordinator
    private let useCase: LoginUseCase
    
    // MARK: Tooling
    private let disposeBag = DisposeBag()
    private var token: String?

    // MARK: - Life cycle
    
    init(
        coordinator: LoginCoordinator,
        configurator: LoginConfigurator
        ) {
        self.coordinator = coordinator
        useCase = LoginUseCase(interactor: configurator.loginInteractor)
        
        observeViewEffect()
    }
}

// MARK: - Public

extension LoginViewModel {
    func bind(to viewAction: PublishRelay< LoginViewAction>) {
        viewAction
            .asObservable()
            .subscribe(onNext: { [unowned self] viewAction in
                switch viewAction {
                case .loginButtonPressed(let input):
                    showNextView(input: input)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private

private extension LoginViewModel {
    func showNextView(input: LoginInputModel) {
        loginUser(input: input)
    }
    
    func loginUser(input: LoginInputModel) {
        useCase.loginUser(input: input)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .loading:
                    viewEffect.accept(.loading)
                case .error(let error):
                    viewEffect.accept(.error(error))
                case .success(let model):
                    handleResponse(input: input, model: model)
                    fetchServers(input: model)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func handleResponse(input: LoginInputModel, model: TokenModel) {
        UserDefaultsProvider.username = input.username
        token = model.token
        storeLoginToken(input: input, token: model.token)
        storeLoginPassword(input: input)
    }
    
    func storeLoginToken(input: LoginInputModel, token: String) {
        let tokenCredentials = Credentials(
            username: input.username,
            token: token
        )
        do {
            try KeychainProvider.storeGenericTokenFor(
                credentials: tokenCredentials,
                serviceType: KeychainProvider.serviceTypeLoginToken
            )
        } catch {}
    }
    
    func storeLoginPassword(input: LoginInputModel) {
        let credentials = Credentials(
            username: input.username,
            token: input.password
        )
        do {
            try KeychainProvider.storeGenericTokenFor(
                credentials: credentials,
                serviceType: KeychainProvider.serviceTypeBiometrics
            )
        } catch {}
    }
    
    func fetchServers(input: TokenModel) {
        useCase.fetchServers(input: input)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .loading:
                    viewEffect.accept(.loading)
                case .error(let error):
                    viewEffect.accept(.error(error))
                case .success(let servers):
                    viewEffect.accept(.success)
                    coordinator.showServerList(
                        servers: servers,
                        token: token.wrappedValue,
                        animated: true
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Rx

private extension LoginViewModel {
    /// - Note: Privately observing view effects in the view model is meant to make the association between a specific effect and certain view states easier.
    func observeViewEffect() {
        viewEffect
            .asObservable()
            .subscribe(onNext: { effect in
                switch effect {
                case .success: break
                case .loading: break
                case   .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}
