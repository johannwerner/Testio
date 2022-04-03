import UIKit

final class ServerHeaderView: UIView {
    // MARK: - Properties
    private let preferredFont = UIFont.preferredFont(forTextStyle: .caption2)
    // MARK: - Components
    private lazy var serverLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.tableViewSectionHeaderTextColor
        label.font = preferredFont
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.tableViewSectionHeaderTextColor
        label.font = preferredFont
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Public
extension ServerHeaderView {
    func fill(serverTitle: String, distanceTitle: String) {
        serverLabel.text = serverTitle
        distanceLabel.text = distanceTitle
    }
}

// MARK: - Private
private extension ServerHeaderView {
    func setUpViews() {
        backgroundColor = ColorTheme.tableViewBackgroundColor
        addServerLabel()
        addDistanceLabel()
    }
    
    func addServerLabel() {
        add(subview: serverLabel)
            .leading(equalTo: self, constant: ServerConstants.appMargin)
            .top(equalTo: self, constant: 14)
            .bottom(equalTo: self, constant: 8)
    }
    
    func addDistanceLabel() {
        add(subview: distanceLabel)
            .leading(greaterThanOrEqualTo: serverLabel.trailingAnchor, constant: 5)
            .centerY(equalTo: serverLabel)
            .trailing(equalTo: self, constant: ServerConstants.appMargin)
    }
}
    
