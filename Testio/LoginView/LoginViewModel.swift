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

    // MARK: - Life cycle
    
    init(
        coordinator: LoginCoordinator,
        configurator: LoginConfigurator
        ) {
        self.coordinator = coordinator
        self.useCase = LoginUseCase(interactor: configurator.loginInteractor)
        
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
                    self.showNextView(input: input)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private functions

private extension LoginViewModel {
    func showNextView(input: LoginInputModel) {
        loginUser(input: input)
    }
    
    func loginUser(input: LoginInputModel) {
        useCase.loginUser(input: input)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .loading:
                    self.viewEffect.accept(.loading)
                case .error:
                    self.viewEffect.accept(.error)
                case .success(let model):
                    do {
                        UserDefaultsUtils.username = input.username ?? ""
                        let credentials = Credentials(
                            username: input.username ?? "",
                            password: input.password ?? ""
                        )
                        try KeychainProvider.storeGenericPasswordFor(credentials: credentials)
                    } catch {}
                    self.getServers(input: model)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getServers(input: TokenModel) {
        useCase.getServers(input: input)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .loading:
                    self.viewEffect.accept(.loading)
                case .error:
                    self.viewEffect.accept(.error)
                case .success(let servers):
                    self.viewEffect.accept(.success)
                    self.coordinator.showServerList(
                        servers: servers,
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
