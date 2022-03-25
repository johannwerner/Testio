import UIKit

struct ColorTheme {
    private init() {}
}

// MARK: - Public

extension ColorTheme {
    static var primaryInteractiveColor: UIColor {
        ColorTheme.colorWith(red: 70, green: 135, blue: 255)
    }
    
    static var activityIndicatorColor: UIColor {
        ColorTheme.colorWith(red: 128, green: 133, blue: 142)
    }
    
    static var tableViewBackgroundColor: UIColor {
        ColorTheme.colorWith(red: 229, green: 229, blue: 229)
    }
    
    static var tableViewSectionHeaderTextColor: UIColor {
        ColorTheme.colorWith(red: 102, green: 102, blue: 102)
    }
}

// MARK: - Private
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
