import RxSwift
import RxCocoa
import UIKit
import TOComponents

/// An introduction to my coding challenge
/// - Requires: `RxSwift`, `RxCocoa`
final class IntroductionViewController: UIViewController {
    // MARK: Dependencies
    private let viewModel: IntroductionModuleViewModel
    
    // MARK: Rx
    private let viewAction = PublishRelay<IntroductionModuleViewAction>()
    
    // MARK: View components
    private let primaryButton: TOButton = {
        let primaryButton = TOButton()
        primaryButton.setTitle(LocalizedKeys.introductionButton, for: .normal)
        primaryButton.backgroundColor = ColorTheme.primaryInteractiveColor
        primaryButton.highlightedBackgroundColor = ColorTheme.primaryInteractiveHighlightColor
        primaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return primaryButton
    }()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: Tooling
    private let disposeBag = DisposeBag()

    // MARK: - Life cycle
    
    init(viewModel: IntroductionModuleViewModel) {
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
        super.viewDidAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Setup

private extension  IntroductionViewController {
    /// Initializes and configures components in controller.
    func setUpViews() {
        setUpTitleLable()
        setUpSubtitleLable()
        setUpNextButton()
    }
    
    
    /// Binds controller user events to view model.
    func setUpBinding() {
        viewModel.bind(to: viewAction)
    }
    
    func setUpTitleLable() {
        view.add(subview: titleLabel)
            .center(inside: view)
        titleLabel.font = UIFont.systemFont(ofSize: 21)
        titleLabel.text = IntroductionConstants.titleLabelText
    }
    
    func setUpSubtitleLable() {
        view.add(subview: subtitleLabel)
            .centerX(equalTo: view)
            .top(equalTo: titleLabel.bottomAnchor, constant: 17)

        subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        let subtitleString = LocalizedKeys.introductionSubtitleText

        let attributesForBold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let attributesForCustom = [NSAttributedString.Key.foregroundColor: ColorTheme.primaryInteractiveColor]

        subtitleLabel.attributedText = AttributedStringProvider.convertStringToAttributedString(
            subtitleString,
            attributesForBold: attributesForBold,
            attributesForCustom: attributesForCustom
        )
    }
    
    func setUpNextButton() {
        view.add(subview: primaryButton)
            .leading(equalTo: view, constant: IntroductionConstants.appMargin)
            .trailing(equalTo: view, constant: IntroductionConstants.appMargin)
            .top(equalTo: subtitleLabel.bottomAnchor, constant: 24)
            .height(equalTo: AppConstants.appleMinimimWidthHeight)
        primaryButton.layer.cornerRadius = 4.0

        primaryButton.backgroundColor = ColorTheme.primaryInteractiveColor

        primaryButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.viewAction.accept(.primaryButtonPressed)
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - Rx

private extension IntroductionViewController {
    /// Starts observing view effects to react accordingly.
    func observeViewEffect() {
        viewModel
        .viewEffect
        .subscribe(onNext: { effect in
            switch effect {
            case .success: break
            case .loading: break
            case .error: break
            }
        })
        .disposed(by: disposeBag)}
}
