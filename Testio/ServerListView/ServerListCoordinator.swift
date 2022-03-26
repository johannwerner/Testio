import UIKit

/// Entry point into app to introduce the app
/// - Requires: `UIKit`
final class ServerListCoordinator {
    // MARK: Dependencies
    private let navigationController: UINavigationController
    private let configurator: ServerListConfigurator
    
    // MARK: Tooling

    // MARK: - Life cycle
    
    init(
        navigationController: UINavigationController,
        configurator: ServerListConfigurator
        ) {
        self.navigationController = navigationController
        self.configurator = configurator
    }
}

// MARK: - Navigation IN

extension  ServerListCoordinator {
    func showServerList(servers: [Server], token: String, animated: Bool) {
        let model = ServerListModel(servers: servers, token: token)
        let viewModel = ServerListViewModel(
            coordinator: self,
            configurator: configurator,
            model: model
        )
        let viewController = ServerListViewController(viewModel: viewModel)
        navigationController.isNavigationBarHidden = false
        navigationController.setViewControllers(
            [viewController],
            animated: true
        )
    }
}

// MARK: - Navigation OUT

extension ServerListCoordinator {
    func showLogin() {
        let interactor = LoginInteractorApi()
        let configurator = LoginConfigurator(loginInteractor: interactor)
        let coordinator = LoginCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        coordinator.showLogin(animated: true)
    }
}
