//
//  Resource.swift
//  DeepRation
//
//  Created by Charles Bethin on 4/25/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import Foundation

struct Resource: Codable {
    let scores: [Double]
    let text: String
    let title: String
    let url: String
}
