//
//  Environment.swift
//  BaseProject
//
//  Created by Daniela Riesgo on 6/27/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

enum Environment {
    
    case Development
    case Alpha
    case Beta
    case Production
    case Test
    
    static var current: Environment {
        let environment = NSProcessInfo.processInfo().environment["ENVIRONMENT"]!.lowercaseString
        if environment == "development" {
            return .Development
        } else if environment == "alpha" {
            return .Alpha
        } else if environment == "beta" {
            return .Beta
        } else if environment == "production" {
            return .Production
        } else if environment == "test" {
            return .Test
        } else {
            fatalError("Environment variable ENVIRONMENT isn't set.")
        }
    }
    
    static var isTestTarget: Bool {
        if case .Test = Environment.current {
            return true
        } else {
            return false
        }
    }
    
    static var isRunningOnSimulator: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
        #else
            return false
        #endif
    }
    
}
