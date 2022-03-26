import RxSwift
import RxCocoa
import UIKit
import TOComponents

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
        sectionHeader.serverLabel.text = LocalizedKeys.server.uppercased()
        sectionHeader.distanceLabel.text = LocalizedKeys.distance.uppercased()
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
        let action = UIAction(handler: { [weak self] _ in
            self?.showFilterView()
        })
        let filterButton = UIBarButtonItem(title: LocalizedKeys.filter, primaryAction: action)
        navigationItem.leftBarButtonItem = filterButton
    }
    
    func setUpDoneButton() {
        let action = UIAction(handler: { [weak self] _ in
            self?.doneAction()
        })
        let doneButton = UIBarButtonItem(title: LocalizedKeys.done, primaryAction: action)
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
        let action = UIAction(handler: { [weak self] _ in
            self?.logout()
        })
        let logoutButton = UIBarButtonItem(title: LocalizedKeys.logout, primaryAction: action)
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func setUpTableView() {
        view.wrap(view: tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
   
    func doneAction() {
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
