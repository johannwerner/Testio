//
//  MainCoordinator.swift
//  Testio
//
//  Created by Johann Werner on 26.03.22.
//

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
    func showMain(animated: Bool) {
        do {
            let token = try KeychainProvider.validToken(username: UserDefaultsProvider.username)
            showServerList(navigationController: navigationController, token: token)
        } catch {
            showLogin(navigationController: navigationController)
        }
    }
}

// MARK: - Navigation OUT

extension  MainCoordinator {
    func showServerList(navigationController: UINavigationController, token: String) {
        let interactor = ServerListInteractorApi()
        let configurator = ServerListConfigurator(serverListInteractor: interactor)
        let coordinator = ServerListCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        coordinator.showServerList(servers: [], token: token, animated: true)
    }
    
    func showLogin(navigationController: UINavigationController) {
        let interactor = LoginInteractorApi()
        let configurator = LoginConfigurator(loginInteractor: interactor)
        let coordinator = LoginCoordinator(
            navigationController: navigationController,
            configurator: configurator
        )
        coordinator.showLogin(animated: true)
    }
}

private extension KeychainProvider {
    static func validToken(username: String?) throws -> String {
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
