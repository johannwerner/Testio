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

func callUnused(run: Bool) {
    unused(IntroductionModuleStatus.success)
    unused(UserDefaultsProperty(userDefaultsKey: "", initalValue: "").wrappedValue)
    unused(ServerListStatus.success)
    let interactor = LoginInteractorApi()
    let configurator = LoginConfigurator(loginInteractor: interactor)
    let coordinator = LoginCoordinator(navigationController: UINavigationController(), configurator: configurator)
    let loginViewModel = LoginViewModel(coordinator: coordinator, configurator: configurator)
    let loginViewController = LoginViewController(viewModel: loginViewModel)
    unused(loginViewController.textFieldShouldReturn(UITextField()))
    loginViewController.textFieldDidEndEditing(UITextField())
    loginViewController.textFieldDidBeginEditing(UITextField())
    if run {
        callUnused(run: false)
    }
}
#endif
