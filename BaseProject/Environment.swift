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
        #if DEVELOPMENT
            return .development
        #endif
        #if ALPHA
            return .alpha
        #endif
        #if BETA
            return .beta
        #endif
        #if PRODUCTION
            return .production
        #endif
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
