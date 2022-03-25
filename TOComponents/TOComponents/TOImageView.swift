//
//  TEImageView.swift
//  Testio
//
//  Created by Johann Werner on 23.03.22.
//

import UIKit

public class TOImageView: UIImageView {
    public init (contentMode: ContentMode = .scaleAspectFit) {
        super.init(frame: .zero)
        self.contentMode = contentMode
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = .scaleAspectFill
    }
}
