import Foundation
import UIKit

extension String {
    var imageInBundle: UIImage? {
        UIImage(named: self)
    }
}

extension Optional where Wrapped == String {
    /// wrappedValue returns the string or if nil returns empty string ""
    var wrappedValue: String {
        guard let self = self else {
            return ""
        }
        return self
    }
}

private extension String {
    /// tableName is Localizable,
    /// missing string will be displayed when no value exists.
    func localizedString(_ comment: String = "") -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            value: "missing string: \(self)",
            comment: comment
        )
    }
}

final class LocalizedKeys {
    private init () {}
    static let username = "username".localizedString()
    static let password = "password".localizedString()
    static let login = "log_in".localizedString()
    static let loadingList = "loading_list".localizedString()
    static let incorrectPassword = "incorrect_password".localizedString()
    static let verificationFailed = "verification_failed".localizedString()
    static let okay = "okay".localizedString()
    static let distancekm = "distance_km".localizedString()
    static let filter = "filter".localizedString()
    static let byDistance = "by_distance".localizedString()
    static let alphabetical = "alphabetical".localizedString()
    static let logout = "logout".localizedString()
    static let done = "done".localizedString()
    static let server = "server".localizedString()
    static let distance = "distance".localizedString()
    static let logIntoAccount = "log_into_account".localizedString()
    static let cancel = "cancel".localizedString()
    static let enterUsernamePassword = "enter_username_password".localizedString()
    static let introductionButton = "introduction_view_primary_button".localizedString()
    static let introductionSubtitleText = "introduction_view_subtitle_text".localizedString()
    static let original = "original".localizedString()
}
