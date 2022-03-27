import UIKit

/// Entry point into app to introduce the app
/// - Requires: `UIKit`
final class LoginCoordinator {
    // MARK: Dependencies
    private let navigationController: UINavigationController
    private let configurator: LoginConfigurator
    
    // MARK: Tooling

    // MARK: - Life cycle
    
    init(
        navigationController: UINavigationController,
        configurator: LoginConfigurator
        ) {
        self.navigationController = navigationController
        self.configurator = configurator
    }
}

// MARK: - Navigation IN

extension  LoginCoordinator {
    func showLogin(animated: Bool) {
        let viewModel = LoginViewModel(
            coordinator: self,
            configurator: configurator
        )
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers(
            [viewController],
            animated: animated
        )
    }
}

// MARK: - Navigation OUT

extension  LoginCoordinator {
    func showServerList(servers: [Server], token: String, animated: Bool) {
        let interactor = ServerListInteractorApi()
        let configurator = ServerListConfigurator(serverListInteractor: interactor)
        let coordinator = ServerListCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        let model = ServerListModel(
            servers: servers,
            token: token,
            fetchFromCache: false
        )
        coordinator.showServerList(model: model, animated: true)
    }
}
