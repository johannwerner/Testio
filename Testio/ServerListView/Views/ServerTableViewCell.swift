//
//  ServerTableViewCell.swift
//  Testio
//
//  Created by Johann Werner on 24.03.22.
//

import UIKit

final class ServerTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var serverNameLabel = UILabel()
    private var distanceLabel = UILabel()

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

extension ServerTableViewCell {
    func fill(server: Server) {
        serverNameLabel.text = server.name
        if let distance = server.distance {
            distanceLabel.text = String(format: LocalizedKeys.distancekm, distance)
        }
    }
}

private extension ServerTableViewCell {
    func setUpViews() {
        selectionStyle = .none
        setUpServerNameLabel()
        setUpDistanceLabel()
    }
    
    func setUpServerNameLabel() {
        contentView.add(subview: serverNameLabel)
            .leading(equalTo: contentView, constant: 16)
            .top(equalTo: contentView, constant: 11)
            .bottom(equalTo: contentView, constant: 11)
    }
    
    func setUpDistanceLabel() {
        contentView.add(subview: distanceLabel)
            .leading(greaterThanOrEqualTo: serverNameLabel.trailingAnchor, constant: 5)
            .trailing(equalTo: contentView, constant: 16)
            .top(equalTo: contentView, constant: 11)
            .bottom(equalTo: contentView, constant: 11)
    }
}
