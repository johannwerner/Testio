import UIKit

final class ServerHeaderView: UIView {
    let serverLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.tableViewSectionHeaderTextColor
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.tableViewSectionHeaderTextColor
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension ServerHeaderView {
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
    
