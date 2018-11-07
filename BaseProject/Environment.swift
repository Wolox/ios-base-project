//
//  Environment.swift
//  BaseProject
//
//  Created by Daniela Riesgo on 6/27/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

internal enum Environment: String {
    
    case debug
    case alpha
    case release
    case production
    
}

internal extension Environment {
    
    static var current: Environment {
        #if DEBUG
            return .debug
        #endif
        #if ALPHA
            return .alpha
        #endif
        #if RELEASE
            return .release
        #endif
        #if PRODUCTION
            return .production
        #endif
    }

}

internal extension Environment {
    
    private static let EnvironmentKey = "ENVIRONMENT"
    
    // This property should be set in scheme Test action's arguments (environment variables).
    private static let EnvironmentTest = "Test"
    
    // This property should be set in UITests by launchEnvironment arguments.
    private static let EnvironmentUITest = "UITest"
    
    static var isTestTarget: Bool {
        let environment = ProcessInfo.processInfo.environment
        return environment[Environment.EnvironmentKey] == Environment.EnvironmentTest
    }
    
    static var isUITestTarget: Bool {
        let environment = ProcessInfo.processInfo.environment
        return environment[Environment.EnvironmentKey] == Environment.EnvironmentUITest
    }
    
}

internal extension Environment {

    static var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
    
}
