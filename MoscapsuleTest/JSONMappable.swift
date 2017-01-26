//
//  JSONMappable.swift
//  MoscapsuleTest
//
//  Created by Stephen Parker on 25/01/2017.
//  Copyright © 2017 aristhome. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONMappable {
    init(jsonObject: JSON)
}
