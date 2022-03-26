import RxCocoa
import RxSwift
import Foundation

///
/// - Requires: `RxSwift`, `RxCocoa`
/// - Note: A view model can refer to one or more use cases.

final class ServerListViewModel {
    // MARK: ViewEffect
    let viewEffect = PublishRelay<ServerListEffect>()
    
    // MARK: Dependencies
    private let coordinator: ServerListCoordinator
    private let useCase: ServerListUseCase
    private var model: ServerListModel
    
    // MARK: Tooling
    private let disposeBag = DisposeBag()

    private var servers: [Server] = []
    private var serversByDistance: [Server] {
        servers.sorted { $0.distanceNonNil < $1.distanceNonNil }
    }
    private var serversByAlphabet: [Server] {
        servers.sorted { $0.nameNonNil < $1.nameNonNil }
    }

    var distanceIndexPath = IndexPath(row: 0, section: 0)
    var alphabetIndexPath = IndexPath(row: 1, section: 0)

    // MARK: - Life cycle
    
    init(
        coordinator: ServerListCoordinator,
        configurator: ServerListConfigurator,
        model: ServerListModel
    ) {
        self.coordinator = coordinator
        self.useCase = ServerListUseCase(interactor: configurator.serverListInteractor)
        self.model = model
        // in case of null values from the server only show servers with values
        
        observeViewEffect()
        fetchServers()
    }
}

// MARK: - Public

extension ServerListViewModel {
    var numberOfItems: Int {
        servers.count
    }
    
    var navigationTitle: String {
        ServerConstants.appName
    }
    
    var selectedFilterIndexPath: IndexPath {
        switch model.sort {
        case .distance:
            return distanceIndexPath
        case .alphabetical:
            return alphabetIndexPath
        }
    }
    
    func serverAt(indexPath: IndexPath) -> Server {
        switch model.sort {
        case .distance:
            return serversByDistance[indexPath.row]
        case .alphabetical:
            return serversByAlphabet[indexPath.row]
        }
    }
    
    func bind(to viewAction: PublishRelay<ServerListViewAction>) {
        viewAction
            .asObservable()
            .subscribe(onNext: { [unowned self] viewAction in
                switch viewAction {
                case .logoutButtonPressed:
                    self.logout()
                case .sortByDistancePressed:
                    sortByDistance()
                case .sortByAlphabetPressed:
                    sortByAlphabet()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private

private extension ServerListViewModel {
    func logout() {
        coordinator.showLogin()
    }
    
    func fetchServers() {
        useCase.getServers()
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .loading:
                    self.viewEffect.accept(.loading)
                case .error:
                    self.viewEffect.accept(.error)
                case .success(let servers):
                    self.servers = servers
                    self.viewEffect.accept(.success)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func sortByDistance() {
        model.sort = .distance
        viewEffect.accept(.success)
    }
    
    func sortByAlphabet() {
        model.sort = .alphabetical
        viewEffect.accept(.success)
    }
}

// MARK: - Rx

private extension ServerListViewModel {
    /// - Note: Privately observing view effects in the view model is meant to make the association between a specific effect and certain view states easier.
    func observeViewEffect() {
        viewEffect
            .asObservable()
            .subscribe(onNext: { effect in
                switch effect {
                case .success: break
                case .loading: break
                case   .error: break
                }
            })
            .disposed(by: disposeBag)
    }
}
