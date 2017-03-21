//
//  Environment.swift
//  BaseProject
//
//  Created by Daniela Riesgo on 6/27/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

enum Environment {
    
    case development
    case alpha
    case beta
    case production
    case test
    
    static var current: Environment {
        let environment = ProcessInfo.processInfo.environment["ENVIRONMENT"]!.lowercased()
        if environment == "development" {
            return .development
        } else if environment == "alpha" {
            return .alpha
        } else if environment == "beta" {
            return .beta
        } else if environment == "production" {
            return .production
        } else if environment == "test" {
            return .test
        } else {
            fatalError("Environment variable ENVIRONMENT isn't set.")
        }
    }
    
    static var isTestTarget: Bool {
        if case .test = Environment.current {
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
