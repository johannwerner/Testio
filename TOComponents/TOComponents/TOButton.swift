import Foundation
import UIKit

open class TOButton: UIButton {
    public override var backgroundColor: UIColor? {
        didSet {
            if setNormalBackgroundColor {
                normalBackgroundColor = backgroundColor
            }
            setNormalBackgroundColor = true
        }
    }
    
    private var normalBackgroundColor: UIColor?
    private var setNormalBackgroundColor = true
    
    public var highlightedBackgroundColor: UIColor?
    public init() {
        super.init(frame: .zero)
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

private extension TOButton {
    func setUp() {
        layer.cornerRadius = ComponentConstants.cornerRadius
        addTarget(self, action: #selector(highlight), for: .touchDragOutside)
        addTarget(self, action: #selector(highlight), for: .touchUpInside)
        addTarget(self, action: #selector(normalState), for: .touchDragInside)
        backgroundColor = normalBackgroundColor
    }
    
    @objc func highlight() {
        backgroundColor = normalBackgroundColor
    }
    
    @objc func normalState() {
        setNormalBackgroundColor(color: highlightedBackgroundColor)
    }
    
    func setNormalBackgroundColor(color: UIColor?) {
        setNormalBackgroundColor = false
        backgroundColor = color
    }
}
