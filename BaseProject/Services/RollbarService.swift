//
//  RollbarService.swift
//  Istali
//
//  Created by Pablo Giorgi on 5/18/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Rollbar
import WolmoCore
import ReactiveSwift

internal final class RollbarService {
    
    fileprivate let _bundle: Bundle
    
    public init(bundle: Bundle = Bundle.main) {
        _bundle = bundle
    }
    
}

internal extension RollbarService {
    
    private static let RollbarClientAccessToken = "ROLLBAR_CLIENT_ACCESS_TOKEN"
    
    func initialize() {
        let configuration = RollbarConfiguration()
        configuration.environment = Environment.current.rawValue
        let rollbarClientAccessToken = _bundle.getString(from: RollbarService.RollbarClientAccessToken)
        Rollbar.initWithAccessToken(rollbarClientAccessToken, configuration: configuration)
    }
    
}
