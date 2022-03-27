import UIKit

final class ServerHeaderView: UIView {
    let serverLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.tableViewSectionHeaderTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.tableViewSectionHeaderTextColor
        label.font = UIFont.systemFont(ofSize: 12)
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
            .leading(equalTo: self, constant: 16)
            .top(equalTo: self, constant: 14)
            .bottom(equalTo: self, constant: 8)
    }
    
    func addDistanceLabel() {
        add(subview: distanceLabel)
            .leading(greaterThanOrEqualTo: serverLabel.trailingAnchor, constant: 5)
            .top(equalTo: self, constant: 14)
            .bottom(equalTo: self, constant: 8)
            .trailing(equalTo: self, constant: 16)
    }
}
    
