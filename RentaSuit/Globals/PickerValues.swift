//
//  PickerValues.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/21/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation

struct PickerValues {
    static let sizeMeasurement : [String] = sizeSet
    
    // breast hips waist
    static var inchesMeasurement : [String] {
        get {
            var arr = [String]()
            for index in 20...100 {
                arr.append(String(format: "%d\"", index))
            }
            return arr
        }
    }
    // height
    static let feetMeasurement : [String] = ["4",
                                        "4'1",
                                        "4'2",
                                        "4'3",
                                        "4'4",
                                        "4'5",
                                        "4'6",
                                        "4'7",
                                        "4'8",
                                        "4'8",
                                        "4'9",
                                        "4'10",
                                        "4'11",
                                        "5",
                                        "5'1",
                                        "5'2",
                                        "5'3",
                                        "5'4",
                                        "5'5",
                                        "5'6",
                                        "5'7",
                                        "5'8",
                                        "5'9",
                                        "5'10",
                                        "5'11",
                                        "6",
                                        "6'1",
                                        "6'2",
                                        "6'3",
                                        "6'4",
                                        "6'5",
                                        "6'6",
                                        "6'7",
                                        "6'8",
                                        "6'9",
                                        "6'10",
                                        "6'11"]
}
