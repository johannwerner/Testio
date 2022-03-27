//
//  TOFilterView.swift
//  Testio
//
//  Created by Johann Werner on 25.03.22.
//

import UIKit

final public class TOFilterView: UIView {
    // MARK: Properties
    private let heightOfOneItem: CGFloat = 60
    private var heightOfTableView: CGFloat {
        heightOfOneItem * CGFloat(items.count)
    }
    private var heightOfTableViewOffset: CGFloat {
        heightOfTableView + 8
    }
    
    private var backgroundView = UIView()
    
    public var selectedIndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            tableView.reloadData()
        }
    }
    public var items: [TOFilterItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.layoutMargins = .zero
        return tableView
    }()
    
    private var tableViewConstraint: NSLayoutConstraint?
    public var backgroundTappedCompletion: (() -> Void)?

    // MARK: LifeCycle
    public init(items: [TOFilterItem]) {
        self.items = items
        super.init(frame: .zero)
        setUp()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

// MARK: Public
public extension TOFilterView {
    func showView() {
        layoutIfNeeded()
        tableViewConstraint?.constant = 8
        UIView.animate(withDuration: ComponentConstants.animationDuration, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.alpha = 1.0
        })
    }
    
    func hideView() {
        layoutIfNeeded()
        tableViewConstraint?.constant = -heightOfTableViewOffset
        UIView.animate(withDuration: ComponentConstants.animationDuration, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
}
// MARK: Datasource
extension TOFilterView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        let item = items[indexPath.row]
        let isSelected = selectedIndexPath == indexPath
        cell.accessoryType = isSelected ? .checkmark: .none
        cell.textLabel?.text = item.itemText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textColor = isSelected ? .systemBlue: .black
        // make cell divider go till the end of the cell
        cell.separatorInset  = .zero
        // above causes offset of title which should be reversed by next two lines
        cell.indentationWidth = 16
        cell.indentationLevel = 1
        return cell
    }
}

// MARK: Delegate
extension TOFilterView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightOfOneItem
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
}

// MARK: Private
private extension TOFilterView {
    func setUp() {
        setUpViews()
        setUpTapGesure()
    }
    
    func setUpViews() {
        alpha = 0
        backgroundColor = ColorTheme.filterViewBackgroundColor
        setUpBackgroundView()
        setUpTableView()
    }
    
    func setUpBackgroundView() {
        wrap(view: backgroundView)
    }
    
    func setUpTableView() {
        add(subview: tableView)
            .leading(equalTo: self, constant: ComponentConstants.filterViewTableViewPadding)
            .trailing(equalTo: self, constant: ComponentConstants.filterViewTableViewPadding)
            .height(equalTo: heightOfTableView)
        
        let constraint = safeAreaLayoutGuide.bottomAnchor.constraint(
            equalTo: tableView.bottomAnchor,
            constant: -heightOfTableViewOffset
        )
        constraint.priority = .required
        constraint.isActive = true
        
        self.tableViewConstraint = constraint
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = ComponentConstants.filterViewButtonCornerRadius
    }
    
    func setUpTapGesure() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundViewTapped)
        )
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundViewTapped() {
        backgroundTappedCompletion?()
    }
}
