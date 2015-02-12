//
//  ReactiveHeimdallSpec.swift
//  ReactiveHeimdall
//
//  Created by Tim Brückmann on 12.02.15.
//  Copyright (c) 2015 B264 GmbH. All rights reserved.
//

import Foundation
import Heimdall
import LlamaKit
import Nimble
import ReactiveHeimdall
import Quick

let testError = NSError(domain: "MockHeimdall", code: 123, userInfo: ["foo": "bar"])
let testRequest = NSURLRequest(URL: NSURL(string: "http://rheinfabrik.de/members")!)

class MockHeimdall: Heimdall {
    
    var authorizeSuccess = true
    var requestSuccess = true
    
    override func authorize(username: String, password: String, completion: Result<Void, NSError> -> ()) {
        if authorizeSuccess {
            completion(success())
        } else {
            completion(failure(testError))
        }
    }
    
    override func requestByAddingAuthorizationToRequest(request: NSURLRequest, completion: Result<NSURLRequest, NSError> -> ()) {
        if requestSuccess {
            completion(success(testRequest))
        } else {
            completion(failure(testError))
        }
    }
    
}

class ReactiveHeimdallSpec: QuickSpec {
    override func spec() {

        var heimdall: MockHeimdall!
        
        beforeEach {
            heimdall = MockHeimdall(tokenURL: NSURL(string: "http://rheinfabrik.de/token")!)
        }
        
        describe("-authorize") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = true
                }
                
                it("completes") {
                    waitUntil { done in
                        let signal = heimdall.authorize("foo", password: "bar")
                        signal.subscribeCompleted {
                            done()
                        }
                    }
                }
                
            }
            
            context("when the completion block sends a failure result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = false
                }
                
                it("sends the error") {
                    waitUntil { done in
                        let signal = heimdall.authorize("foo", password: "bar")
                        signal.subscribeError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
                    }
                }
                
            }
            
        }
        
        describe ("-requestByAddingAuthorizationToRequest") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.requestSuccess = true
                }
                
                it("sends the result value") {
                    waitUntil { done in
                        let signal = heimdall.requestByAddingAuthorizationToRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signal.subscribeNext { value in
                            expect(value as? NSURLRequest).to(equal(testRequest))
                            done()
                        }
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signal = heimdall.requestByAddingAuthorizationToRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signal.subscribeCompleted {
                            done()
                        }
                    }
                }
                
            }
            
            context("when the completion block sends a failure result") {
                
                beforeEach {
                    heimdall.requestSuccess = false
                }
                
                it("sends the error") {
                    waitUntil { done in
                        let signal = heimdall.requestByAddingAuthorizationToRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signal.subscribeError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
                    }
                }
                
            }
            
        }
        
    }
}
