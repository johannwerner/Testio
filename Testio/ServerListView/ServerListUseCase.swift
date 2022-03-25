import RxSwift
/// Server Use case
/// - Requires: RxSwift
final class ServerListUseCase {
    // MARK: Dependencies
    private let interactor: ServerListInteractor
    
    // MARK: - Life cycle
    
    init(interactor: ServerListInteractor) {
        self.interactor = interactor
    }
}

// MARK: - Public

extension ServerListUseCase {}
