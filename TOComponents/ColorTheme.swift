import UIKit

struct ColorTheme {
    private init() {}
}

// MARK: - Public Methods

extension ColorTheme {
    static var textFieldTextColor: UIColor {
        ColorTheme.colorWith(red: 60, green: 60, blue: 67)
    }
    
    static var textFieldPlaceholderColor: UIColor {
        ColorTheme.colorWith(red: 60, green: 60, blue: 67, alpha: 0.6)
    }
    
    static var textFieldCursorColor: UIColor {
        ColorTheme.colorWith(red: 70, green: 135, blue: 255)
    }
    
    static var textFieldBackgroundColor: UIColor {
        ColorTheme.colorWith(red: 118, green: 118, blue: 118, alpha: 0.12)
    }
    
    static var filterViewBackgroundColor: UIColor {
        ColorTheme.blackWithAlpha(alpha: 0.4)
    }
}

// MARK: - Private Methods
private extension ColorTheme {
    static func blackWithAlpha(alpha: CGFloat) -> UIColor {
        ColorTheme.colorWith(
            red: 0,
            green: 0,
            blue: 0,
            alpha: alpha
        )
    }
    
    static func whiteWithAlpha(alpha: CGFloat) -> UIColor {
        ColorTheme.colorWith(
            red: 255,
            green: 255,
            blue: 255,
            alpha: alpha
        )
    }
    /**
    Red/Blue /Green from 0 to 255 to create a color. Do not use divide by /255 because this is being done here.
    */
    static func colorWith(
        red: UInt8,
        green: UInt8,
        blue: UInt8,
        alpha: CGFloat = 1.0
        ) -> UIColor {
        UIColor(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }
}
