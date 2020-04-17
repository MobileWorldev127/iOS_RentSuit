//
//  MABMapper.swift
//  SwiftMABMapper
//
//  Created by Med Amine Ben Salah on 13/10/2017.
//  Copyright © 2017 Anypli. All rights reserved.
//

import Foundation

protocol MABMapper : NSObjectProtocol{
 static func map() -> Dictionary<String,Any>;
}
