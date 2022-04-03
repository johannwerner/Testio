import CoreGraphics
/// View effect enum for  IntroductionModule.
enum IntroductionModuleViewEffect {
    case success
    case loading
    case error
}

/// View action enum for  IntroductionModule.
enum IntroductionModuleViewAction {
    case primaryButtonPressed
}

struct IntroductionConstants {
    private init() {}
    static let titleLabelText = "Johann Werner"
    static let appMargin: CGFloat = 32
}
