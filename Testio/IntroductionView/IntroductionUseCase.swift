import RxSwift
/// An introduction to the app
/// - Requires:
final class IntroductionUseCase {
    // MARK: Dependencies
    private let interactor: IntroductionInteractor
    
    // MARK: - Life cycle
    
    init(interactor: IntroductionInteractor) {
        self.interactor = interactor
    }
}

// MARK: - Public functions

extension IntroductionUseCase {}
