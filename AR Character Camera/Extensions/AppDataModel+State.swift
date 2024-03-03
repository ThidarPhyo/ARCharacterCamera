//
//  AppDataModel+State.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/06.
//

import Foundation

extension AppDataModel {
    enum ModelState: String, CustomStringConvertible {
        var description: String { rawValue }

        case notSet
        case ready
        case capturing
        case prepareToReconstruct
        case reconstructing
        case viewing
        case completed
        case restart
        case failed
    }
}
