import UIKit

final class MainCoordinator {
    // MARK: Dependencies
    private let navigationController: UINavigationController
    
    // MARK: Tooling

    // MARK: - Life cycle
    
    init(
        navigationController: UINavigationController
        ) {
        self.navigationController = navigationController
    }
}

// MARK: - Navigation IN

extension  MainCoordinator {
    func start(animated: Bool) {
        if UserDefaultsProvider.hideIntroduction {
            showMain(animated: true)
        } else {
            showIntroduction(navigationController: navigationController, animated: true)
        }
        return
    }
}

// MARK: - Navigation OUT

extension  MainCoordinator {
    func showMain(animated: Bool) {
        do {
            let token = try KeychainProvider.validToken(
                username: UserDefaultsProvider.username,
                animated: animated
            )
            showServerList(
                navigationController: navigationController,
                token: token,
                animated: animated
            )
        } catch {
            showLogin(navigationController: navigationController, animated: true)
        }
    }
    
    func showServerList(navigationController: UINavigationController, token: String, animated: Bool) {
        let interactor = ServerListInteractorApi()
        let configurator = ServerListConfigurator(serverListInteractor: interactor)
        let coordinator = ServerListCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        let model = ServerListModel(
            servers: [],
            token: token,
            fetchFromCache: true
        )
        coordinator.showServerList(model: model, animated: true)
    }
    
    func showLogin(navigationController: UINavigationController, animated: Bool) {
        let interactor = LoginInteractorApi()
        let configurator = LoginConfigurator(loginInteractor: interactor)
        let coordinator = LoginCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        coordinator.showLogin(animated: animated)
    }
    
    func showIntroduction(navigationController: UINavigationController, animated: Bool) {
        UserDefaultsProvider.hideIntroduction = true
        let interactor = IntroductionInteractorApi()
        let configurator = IntroductionConfigurator(introductionInteractor: interactor)
        let coordinator = IntroductionCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        coordinator.showIntroduction(animated: animated)
    }
}

private extension KeychainProvider {
    static func validToken(username: String?, animated: Bool) throws -> String {
        guard let username = username else {
            throw KeychainError.tokenNotValid
        }
        let token = try KeychainProvider.getGenericTokenFor(
            username: username,
            serviceType: KeychainProvider.serviceTypeLoginToken
        )
        if token.isEmpty {
            throw KeychainError.tokenNotValid
        }
        return token
    }
}
