import UIKit

final class ServerTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var serverNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var dividerView = UIView()

    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Public
extension ServerTableViewCell {
    func fill(server: Server) {
        serverNameLabel.text = server.name
        if let distance = server.distance {
            distanceLabel.text = String(format: LocalizedKeys.distancekm, distance)
        }
    }
}

// MARK: - Private
private extension ServerTableViewCell {
    func setUpViews() {
        selectionStyle = .none
        setUpServerNameLabel()
        setUpDistanceLabel()
        setUpDividerView()
    }
    
    func setUpServerNameLabel() {
        contentView.add(subview: serverNameLabel)
            .leading(equalTo: contentView, constant: ServerConstants.appMargin)
            .top(equalTo: contentView, constant: 11)
            .bottom(equalTo: contentView, constant: 11)
    }
    
    func setUpDistanceLabel() {
        contentView.add(subview: distanceLabel)
            .leading(greaterThanOrEqualTo: serverNameLabel.trailingAnchor, constant: 5)
            .trailing(equalTo: contentView, constant: ServerConstants.appMargin)
            .centerY(equalTo: contentView)
    }
    
    func setUpDividerView() {
        add(subview: dividerView)
            .leading(equalTo: self, constant: 16)
            .bottom(equalTo: self)
            .trailing(equalTo: self)
            .height(equalTo: 0.5)
        
        dividerView.backgroundColor = ColorTheme.tableViewDividerColor
    }
}
