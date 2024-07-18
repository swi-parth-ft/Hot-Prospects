//
//  Prospect.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var email: String
    var isContacted: Bool
    
    init(name: String, email: String, isContacted: Bool) {
        self.name = name
        self.email = email
        self.isContacted = isContacted
    }
}
