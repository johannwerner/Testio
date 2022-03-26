import RxSwift
import RxCocoa
import UIKit
import TOComponents
import LocalAuthentication

/// Login View
/// - Requires: `RxSwift`, `RxCocoa`, `UIKit`, `TOComponents`, `LocalAuthentication`
final class LoginViewController: UIViewController {
    // MARK: Dependencies
    private let viewModel: LoginViewModel
    
    // MARK: Rx
    private let viewAction = PublishRelay<LoginViewAction>()
    
    // MARK: View components
    private let backgroundImage = TOImageView()
    private let logoImageView = TOImageView()
    private let containerView = UIView()
    private var usernameTextFieldTopConstraint: NSLayoutConstraint?
    private lazy var usernameTextField: TOTextField = {
        let textField = TOTextField(textFieldType: .username)
        textField.placeholder = LocalizedKeys.username
        textField.leftIcon = LoginConstants.usernameIconImage.imageInBundle
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: TOTextField = {
        let textField = TOTextField(textFieldType: .password)
        textField.placeholder = LocalizedKeys.password
        textField.leftIcon = LoginConstants.passwordIconImage.imageInBundle
        textField.delegate = self
        return textField
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.layer.cornerRadius = LoginConstants.cornerRadius
        loginButton.setTitle(LocalizedKeys.login, for: .normal)
        loginButton.backgroundColor = ColorTheme.primaryInteractiveColor
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return loginButton
    }()
    
    private let activityIndicator = TOActivityIndicator(text: LocalizedKeys.loadingList)
    
    private var input: LoginInputModel {
        LoginInputModel(
            username: usernameTextField.text,
            password: passwordTextField.text
        )
    }

    // MARK: Tooling
    private let disposeBag = DisposeBag()

    // MARK: - Life cycle
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpBinding()
        observeViewEffect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNotificationKeyboard()
        setUpBiometricsLogin()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotificationKeyboard()
    }
}

// MARK: - Private

private extension  LoginViewController {
    func biometricsLogin(username: String, password: String) {
        let context = LAContext()
        context.localizedCancelTitle = LocalizedKeys.cancel

        let reason = LocalizedKeys.logIntoAccount
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { [weak self] success, _ in
            if success {
                DispatchQueue.main.async {
                    let input = LoginInputModel(username: username, password: password)
                    self?.viewAction.accept(.loginButtonPressed(input: input))
                }
            }
        }
    }
    

    /// Initializes and configures components in controller.
    func setUpViews() {
        setUpBackgroundImage()
        setUpContainerView()
        setUpUsernameTextField()
        setUpLogoImage()
        setUpPasswordTextField()
        setUpLoginButton()
        setUpActivityIndicator()
        addTapGesture()
    }
    
    
    /// Binds controller user events to view model.
    func setUpBinding() {
        viewModel.bind(to: viewAction)
    }
    
    func setUpBackgroundImage() {
        view.add(subview: backgroundImage)
            .leading(equalTo: view)
            .trailing(equalTo: view)
            .bottom(equalTo: view)
        backgroundImage.image = LoginConstants.loginBottomImage.imageInBundle
    }
    
    func setUpContainerView() {
        view.add(subview: containerView)
            .leading(equalTo: view)
            .trailing(equalTo: view)
            .top(equalTo: view, constant: 40)
            .bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func setUpUsernameTextField() {
        containerView.add(subview: usernameTextField)
            .leading(equalTo: containerView, constant: LoginConstants.appMargin)
            .trailing(equalTo: containerView, constant: LoginConstants.appMargin)
        
        let constraint = NSLayoutConstraint(
            item: usernameTextField,
            attribute: .top,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .top,
            multiplier: 1,
            constant: 221
        )
        view.addConstraint(constraint)
        constraint.isActive = true
        usernameTextFieldTopConstraint = constraint
    }
    
    func setUpLogoImage() {
        containerView.add(subview: logoImageView)
            .bottom(equalTo: usernameTextField.topAnchor, constant: 40)
            .centerX(equalTo: containerView)
            
        logoImageView.image = LoginConstants.loginLogo.imageInBundle
    }
    
    func setUpPasswordTextField() {
        containerView.add(subview: passwordTextField)
            .leading(equalTo: containerView, constant: LoginConstants.appMargin)
            .trailing(equalTo: containerView, constant: LoginConstants.appMargin)
            .top(equalTo: usernameTextField.bottomAnchor, constant: 24)
    }
    
    func setUpLoginButton() {
        containerView.add(subview: loginButton)
            .leading(equalTo: containerView, constant: LoginConstants.appMargin)
            .trailing(equalTo: containerView, constant: LoginConstants.appMargin)
            .top(equalTo: passwordTextField.bottomAnchor, constant: 24)
            .height(equalTo: LoginConstants.appleMinimimWidthHeight)
            // Apple recomends 44 design uses 40
            // find out which height to use
        
        loginButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            guard self.input.isValidInput else {
                self.handleError(error: LocalizedKeys.enterUsernamePassword)
                return
            }
            self.viewAction.accept(.loginButtonPressed(input: self.input))
        })
        .disposed(by: disposeBag)
    }

    func setUpActivityIndicator() {
        view.add(subview: activityIndicator)
            .center(inside: view)

        activityIndicator.color = ColorTheme.activityIndicatorColor
    }
    
    func startLoadingAnimations() {
        activityIndicator.startAnimating()
        containerView.alpha = 0.0
        loginButton.alpha = 0.0
        endEditing()
    }
    
    func resetView() {
        UIView.animate(withDuration: 0.2, animations: { [weak self]  in
            self?.containerView.alpha = 1.0
            self?.loginButton.alpha = 1.0
        })
        containerView.alpha = 1.0
        loginButton.alpha = 1.0
        stopLoadingAnimations()
    }
    
    @objc func endEditing() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func stopLoadingAnimations() {
        activityIndicator.stopAnimating()
    }
    
    func handleError(error: String?) {
        stopLoadingAnimations()
        resetView()
        showAlert(
            title: LocalizedKeys.verificationFailed,
            message: error ?? LocalizedKeys.incorrectPassword
        )
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizedKeys.okay, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        usernameTextFieldTopConstraint?.constant = 100
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        usernameTextFieldTopConstraint?.constant = 221
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    func setUpBiometricsLogin() {
        do {
            if let username = UserDefaultsProvider.username {
                let data = try KeychainProvider.getGenericTokenFor(
                    username: username, serviceType:
                        KeychainProvider.serviceTypeBiometrics
                )
                biometricsLogin(username: username, password: data)
            }
        } catch {}
    }
    
    func setNotificationKeyboard () {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeNotificationKeyboard () {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewAction.accept(.loginButtonPressed(input: input))
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textField = textField as? TOTextField {
            textField.isActive = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textField = textField as? TOTextField {
            textField.isActive = true
        }
    }
}


// MARK: - Rx

private extension LoginViewController {
    /// Starts observing view effects to react accordingly.
    func observeViewEffect() {
        viewModel
        .viewEffect
        .subscribe(onNext: { [unowned self] effect in
            switch effect {
            case .success:
                self.stopLoadingAnimations()
            case .loading:
                self.startLoadingAnimations()
            case .error(let error):
                self.handleError(error: error)
            }
        })
        .disposed(by: disposeBag)}
}
