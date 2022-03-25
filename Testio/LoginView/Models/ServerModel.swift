//
//  ServerModel.swift
//  Testio
//
//  Created by Johann Werner on 23.03.22.
//

import Foundation
import RxSwift

enum ServerStatus {
    case loading
    case error(String?)
    case success([Server])
}

struct Server: Codable {
    var name: String?
    var distance: Int?
    
    var distanceNonNil: Int {
        distance ?? Int.max
    }
    
    var nameNonNil: String {
        name ?? ""
    }
}
