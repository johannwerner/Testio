import UIKit

/// Entry point into app to introduce the app
/// - Requires: `UIKit`
final class IntroductionCoordinator {
    // MARK: Dependencies
    private let navigationController: UINavigationController
    private let configurator: IntroductionConfigurator
    
    // MARK: Tooling

    // MARK: - Life cycle
    
    init(
        navigationController: UINavigationController,
        configurator: IntroductionConfigurator
        ) {
        self.navigationController = navigationController
        self.configurator = configurator
    }
}

// MARK: - Navigation IN

extension  IntroductionCoordinator {
    func showIntroduction(animated: Bool) {
        let viewModel = IntroductionModuleViewModel(
            coordinator: self,
            configurator: configurator
        )
        let viewController = IntroductionViewController(viewModel: viewModel)
        navigationController.pushViewController(
            viewController,
            animated: animated
        )
    }
}

// MARK: - Navigation OUT

extension  IntroductionCoordinator {
    func showLogin(animated: Bool) {
        UserDefaultsProvider.hideIntroduction = true
        let interactor = LoginInteractorApi()
        let configurator = LoginConfigurator(loginInteractor: interactor)
        let coordinator = LoginCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        coordinator.showLogin(animated: animated)
    }
}
