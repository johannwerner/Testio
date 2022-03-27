//
//  TOActivityIndicator.swift
//  Testio
//
//  Created by Johann Werner on 23.03.22.
//

import UIKit

open class TOActivityIndicator: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    public var color: UIColor? {
        didSet {
            activityIndicator.color = color
            label.textColor = color
        }
    }
    public init(text: String?) {
        self.text = text
        super.init(frame: .zero)
        setUpViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

public extension TOActivityIndicator {
    func startAnimating() {
        label.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        label.isHidden = true
        activityIndicator.stopAnimating()
    }
}

private extension TOActivityIndicator {
    func setUpViews() {
        accessibilityHint = text
        isAccessibilityElement = true
        setUpActivityIndicator()
        setUpLabel()
        stopAnimating()
    }
    
    func setUpActivityIndicator() {
        add(subview: activityIndicator)
            .top(equalTo: self)
            .centerX(equalTo: self)
       
        activityIndicator.hidesWhenStopped = true
        
        if label.font.pointSize > 16 {
            activityIndicator.style = .large
        }
    }
    
    func setUpLabel() {
        add(subview: label)
            .top(equalTo: activityIndicator.bottomAnchor, constant: 8)
            .leading(equalTo: self)
            .trailing(equalTo: self)
            .bottom(equalTo: self)
        label.textColor = .black
        label.text = text
    }
}
