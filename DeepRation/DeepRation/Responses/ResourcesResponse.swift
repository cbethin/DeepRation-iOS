//
//  ResourcesResponse.swift
//  DeepRation
//
//  Created by Charles Bethin on 4/25/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import Foundation

class ResourcesResponse: Codable {
    var status: String = ""
    var resources: [Resource] = []
}
