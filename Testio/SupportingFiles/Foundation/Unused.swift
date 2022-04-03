//
//  Unused.swift
//  Testio
//
//  Created by Johann Werner on 28.03.22.
//  File not used and not added to target, just used to silence unused false postives and intended postives.
#if DEBUG
import Foundation
import TOComponents
import UIKit

private var loginViewController: LoginViewController = {
    let interactor = LoginInteractorApi()
    let configurator = LoginConfigurator(loginInteractor: interactor)
    let coordinator = LoginCoordinator(navigationController: UINavigationController(), configurator: configurator)
    let loginViewModel = LoginViewModel(coordinator: coordinator, configurator: configurator)
    let loginViewController = LoginViewController(viewModel: loginViewModel)
}()

private func callUnused(run: Bool) {
    // Intended Positives
    unused(IntroductionModuleStatus.success)
    // False Positives
    unused(UserDefaultsProperty(userDefaultsKey: "", initalValue: "").wrappedValue)
    unused(loginViewController.textFieldShouldReturn(UITextField()))
    loginViewController.textFieldDidEndEditing(UITextField())
    loginViewController.textFieldDidBeginEditing(UITextField())
    // call callUnused so it iself is not unused.
    if run {
        callUnused(run: false)
    }
}

public func unused(_ items: Any) {}
#endif
