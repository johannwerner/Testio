import RxSwift
import RxCocoa
import UIKit
import TOComponents
import TOLogger

/// Server List View
/// - Requires: `RxSwift`, `RxCocoa`,  `UIKit`, `TOComponents`
final class ServerListViewController: UIViewController {
    // MARK: Dependencies
    private let viewModel: ServerListViewModel
    
    // MARK: Rx
    private let viewAction = PublishRelay<ServerListViewAction>()
    
    // MARK: View components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ServerTableViewCell.self, forCellReuseIdentifier: ServerTableViewCell.reuseId)
        tableView.backgroundColor = ColorTheme.tableViewBackgroundColor
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var filterView: TOFilterView?
    // MARK: Tooling
    private let disposeBag = DisposeBag()

    // MARK: - Life cycle
    
    init(viewModel: ServerListViewModel) {
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
        setUpNavigationBar()
        setUpBinding()
        observeViewEffect()
    }
    
    deinit {
        print("dinit \(self)")
    }
}

// MARK: - UITableViewDataSource
extension ServerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ServerTableViewCell.reuseId,
            for: indexPath
        ) as? ServerTableViewCell else {
            Logger.logError("cell is not typeServerTableViewCell")
            return UITableViewCell()
        }
        let server = viewModel.serverAt(indexPath: indexPath)
        cell.fill(server: server)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ServerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = ServerHeaderView()
        sectionHeader.fill(
            serverTitle: LocalizedKeys.server.uppercased(),
            distanceTitle: LocalizedKeys.distance.uppercased()
        )
        return sectionHeader
    }
}

// MARK: - Setup

private extension  ServerListViewController {
    /// Initializes and configures components in controller.
    func setUpViews() {
        setUpTableView()
    }
    
    func setUpNavigationBar() {
        title = viewModel.navigationTitle
        setUpFilterButton()
        setUpLogOutButton()
    }
    
    func setUpFilterButton() {
        tableView.scrollsToTop = true
        let image = ServerConstants.filterButtonImage.imageInBundle
        let filterButtonView = TOBarButtonView(
            imagePosition: .left(image),
            buttonText: LocalizedKeys.filter,
            target: self,
            action: #selector(showFilterView)
        )
        let filterButton = UIBarButtonItem(customView: filterButtonView)
        navigationItem.leftBarButtonItem = filterButton
    }
    
    func setUpDoneButton() {
        let doneButton = UIBarButtonItem(
            title: LocalizedKeys.done,
            style: .done,
            target: self,
            action: #selector(doneAction)
        )
        navigationItem.leftBarButtonItem = doneButton
    }

    @objc func showFilterView() {
        setUpDoneButton()
        tableView.scrollsToTop = false
        let filterItemByDistance = TOFilterItem(itemText: LocalizedKeys.byDistance)
        let filterItemByAlphabetical = TOFilterItem(itemText: LocalizedKeys.alphabetical)
        let filterView = TOFilterView(items: [filterItemByDistance, filterItemByAlphabetical])
        filterView.selectedIndexPath = viewModel.selectedFilterIndexPath
        view.wrap(view: filterView)
        filterView.showView()
        filterView.backgroundTappedCompletion = { [weak self] in
            self?.doneAction()
        }
        self.filterView = filterView
    }
    
    func setUpLogOutButton() {
        let image = ServerConstants.logoutImage.imageInBundle
        let logoutButtonView = TOBarButtonView(
            imagePosition: .right(image),
            buttonText: LocalizedKeys.logout,
            target: self,
            action: #selector(logout)
        )
        let logoutButton = UIBarButtonItem(customView: logoutButtonView)
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func setUpTableView() {
        view.wrap(view: tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
   
    @objc func doneAction() {
        if filterView?.selectedIndexPath == viewModel.distanceIndexPath {
            viewAction.accept(.sortByDistancePressed)
        } else {
            viewAction.accept(.sortByAlphabetPressed)
        }
        setUpFilterButton()
        removeFilterView()
    }
    
    func removeFilterView() {
        filterView?.hideView()
        setUpFilterButton()
    }
    
    @objc func logout() {
        viewAction.accept(.logoutButtonPressed)
    }
    
    /// Binds controller user events to view model.
    func setUpBinding() {
        viewModel.bind(to: viewAction)
    }
}


// MARK: - Rx

private extension ServerListViewController {
    /// Starts observing view effects to react accordingly.
    func observeViewEffect() {
        viewModel
        .viewEffect
        .subscribe(onNext: { [unowned self] effect in
            switch effect {
            case .success:
                tableView.reloadData()
            case .loading: break // Data is loaded in background
            case .error: break
            }
        })
        .disposed(by: disposeBag)}
}
