//
//  WBooksTests.swift
//  WBooksTests
//
//  Created by Guido Marucci Blas on 4/3/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
import WBooks

final class WBooksSpec: QuickSpec {
    
    override func spec() {
        
        describe("#someInstanceMethod") {
            
            context("when there is some condition in the context") {
                
                it("asserts that the expected behavior occurs") {
                    expect(1).to(equal(1))
                }
                
            }
            
        }
        
    }
    
}
