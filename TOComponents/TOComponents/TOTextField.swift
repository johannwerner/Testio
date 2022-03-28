import UIKit
import TOLogger

public enum TextFieldType {
    case standard
    case username
    case password
}

open class TOTextField: UITextField {
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
        tintColor = ColorTheme.textFieldCursorColor
        font = UIFont.systemFont(ofSize: 17)
        layer.cornerRadius = ComponentConstants.cornerRadius
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
            return Logger.logError("placeholder is nil")
        }
        let attributedString = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: ColorTheme.textFieldPlaceholderColor]
        )
        attributedPlaceholder = attributedString
    }
    
    func setLeftIcon(icon: UIImage?) {
        guard let icon = icon else {
            leftViewMode = .never
            leftView = nil
            Logger.logError("image is nil")
            return
        }
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
        // Below causes autolayout constraint to break
        // but fixes issue with icon jumping.
        layoutIfNeeded()
    }
}
