import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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
        showMain(navigationController: startNavigationController)
        return true
    }
          
    func makeNavigationControllerMain(navigationController: UINavigationController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        window.rootViewController = navigationController
    }
          
    func showMain(navigationController: UINavigationController) {
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start(animated: true)
    }
}
