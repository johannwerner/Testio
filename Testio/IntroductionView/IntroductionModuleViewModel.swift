import RxCocoa
import RxSwift

///
/// - Requires: `RxSwift`, `RxCocoa`
/// - Note: A view model can refer to one or more use cases.

final class IntroductionModuleViewModel {
    // MARK: ViewEffect
    let viewEffect = PublishRelay< IntroductionModuleViewEffect>()
    
    // MARK: Dependencies
    private let coordinator: IntroductionCoordinator
    private let useCase: IntroductionUseCase
    
    // MARK: Tooling
    private let disposeBag = DisposeBag()

    // MARK: - Life cycle
    
    init(
        coordinator: IntroductionCoordinator,
        configurator: IntroductionConfigurator
        ) {
        self.coordinator = coordinator
        self.useCase = IntroductionUseCase(interactor: configurator.introductionInteractor)
        
        observeViewEffect()
    }
}

// MARK: - Public functions

extension IntroductionModuleViewModel {
    func bind(to viewAction: PublishRelay< IntroductionModuleViewAction>) {
        viewAction
            .asObservable()
            .subscribe(onNext: { [unowned self] viewAction in
                switch viewAction {
                case .primaryButtonPressed:
                    self.showLoginView()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private functions

private extension IntroductionModuleViewModel {
    func showLoginView() {
        coordinator.showLogin(animated: true)
    }
}

// MARK: - Rx

private extension IntroductionModuleViewModel {
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
