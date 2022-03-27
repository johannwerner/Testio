// TODO: Clean Up needed

import Foundation
import UIKit

public enum BarButtonViewImagePosition {
    case left(UIImage?)
    case right(UIImage?)
}

final public class TOBarButtonView: UIView {
    private let highlightedColor = UIColor.systemBlue.withAlphaComponent(0.4)
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()

    private var target: Any?
    private var action: Selector?
    
    public init(imagePosition: BarButtonViewImagePosition, buttonText: String, target: Any?, action: Selector?) {
        self.target = target
        self.action = action
        super.init(frame: .zero)
        setUpViews()
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(highlightedColor, for: .highlighted)
        setButtonImage(imagePosition: imagePosition)
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

public extension TOBarButtonView {
    func setUpViews() {
        addButtonLabel()
    }
    
    func setButtonImage(imagePosition: BarButtonViewImagePosition) {
        switch imagePosition {
        case .left(let image):
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if let image = image {
                button.setImage(image.withTintColor(highlightedColor), for: .highlighted)
            }
        case .right(let image):
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            button.addRightImage(image: image, highlightedColor: highlightedColor)
        }
    }

    func addButtonLabel() {
        add(subview: button)
            .leading(equalTo: self)
            .trailing(equalTo: self, constant: 5)
            .top(equalTo: self)
            .bottom(equalTo: self)
    }
}

private extension UIButton {
    func addRightImage(image: UIImage?, highlightedColor: UIColor) {
        guard let image = image else {
            return
        }
        setImage(image, for: .normal)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15).isActive = true
        setImage(image.withTintColor(highlightedColor), for: .highlighted)
    }
}
