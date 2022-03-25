//
//  AppDelegate.swift
//  Testio
//
//  Created by Johann Werner on 22.03.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startApp()
    }
}

private extension AppDelegate {
    func startApp() -> Bool {
        showFirstView()
    }
          
    func showFirstView() -> Bool {
        let startNavigationController = UINavigationController()
        startNavigationController.isNavigationBarHidden = true
        makeNavigationControllerMain(navigationController: startNavigationController)
        showLogin(navigationController: startNavigationController)
        return true
    }
          
    func makeNavigationControllerMain(navigationController: UINavigationController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        window.rootViewController = navigationController
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
