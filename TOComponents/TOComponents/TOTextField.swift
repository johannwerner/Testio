//
//  TOTextField.swift
//  Testio
//
//  Created by Johann Werner on 23.03.22.
//

import UIKit

public enum TextFieldType {
    case standard
    case username
    case password
}

public class TOTextField: UITextField {
    // MARK: Properties
    var textFieldType: TextFieldType {
        didSet {
            configureTextfield()
        }
    }
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftIconMargin
        return textRect
    }
    
    private var leftIconMargin: CGFloat = 13
    private var iconSize: CGFloat = 14
    private var iconRightPadding: CGFloat = 9

    public override var placeholder: String? {
        didSet {
            setPlaceholder(placeholder: placeholder)
        }
    }
    public var leftIcon: UIImage? {
        didSet {
            setLeftIcon(icon: leftIcon)
        }
    }
    
    public var isActive = false {
        didSet {
            setLeftIcon(icon: leftIcon)
        }
    }
    // MARK: LifeCycle
    public init(textFieldType: TextFieldType = .standard) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        layoutUI()
    }
    
    required public init?(coder: NSCoder) {
        textFieldType = .standard
        super.init(coder: coder)
        layoutUI()
    }
}

private extension TOTextField {
    func layoutUI() {
        layer.cornerRadius = ComponentConstants.cornerRadius
        height(equalTo: 40)
        configureTextfield()
        textColor = ColorTheme.textFieldTextColor
        backgroundColor = ColorTheme.textFieldBackgroundColor
    }
    
    func configureTextfield() {
        switch textFieldType {
        case .username:
            autocapitalizationType = .none
            autocorrectionType = .no
            textContentType = .username
            keyboardType = .default
            isSecureTextEntry = false
            returnKeyType = .go
        case .password:
            autocapitalizationType = .none
            autocorrectionType = .no
            textContentType = .password
            keyboardType = .default
            isSecureTextEntry = true
            returnKeyType = .go
        case .standard:
            autocapitalizationType = .sentences
            autocorrectionType = .yes
            textContentType = .none
            keyboardType = .default
            isSecureTextEntry = false
            returnKeyType = .default
        }
    }
    
    func setPlaceholder(placeholder: String?) {
        guard let placeholder = placeholder else {
            return
        }
        let attributedString = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: ColorTheme.textFieldPlaceholderColor]
        )
        attributedPlaceholder = attributedString
    }
    
    func handleActiveState() {
        if isActive {
            setLeftIcon(icon: leftIcon?.withTintColor(ColorTheme.textFieldTextColor))
        } else {
            setLeftIcon(icon: leftIcon?.withTintColor(ColorTheme.textFieldPlaceholderColor))
        }
    }
    
    func setLeftIcon(icon: UIImage?) {
        if let icon = icon {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + iconRightPadding, height: iconSize))
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
            imageView.contentMode = .scaleAspectFill
            imageView.image = icon
            if isActive {
                imageView.image = icon.withTintColor(ColorTheme.textFieldTextColor)
            } else {
                imageView.image = icon.withTintColor(ColorTheme.textFieldPlaceholderColor)
            }
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = .never
            leftView = nil
        }
    }
}
