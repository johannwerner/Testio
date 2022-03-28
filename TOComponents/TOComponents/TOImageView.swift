import UIKit

open class TOImageView: UIImageView {
    public init (contentMode: ContentMode = .scaleAspectFit) {
        super.init(frame: .zero)
        self.contentMode = contentMode
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = .scaleAspectFill
    }
}
