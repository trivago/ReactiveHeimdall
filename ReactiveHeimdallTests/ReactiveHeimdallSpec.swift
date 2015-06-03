import Foundation
import Heimdall
import Nimble
import Quick
import ReactiveCocoa
import ReactiveHeimdall
import Result

let testError = NSError(domain: "MockHeimdall", code: 123, userInfo: ["foo": "bar"])
let testRequest = NSURLRequest(URL: NSURL(string: "http://rheinfabrik.de/members")!)

class MockHeimdall: Heimdall {
    
    var authorizeSuccess = true
    var requestSuccess = true
    
    override func requestAccessToken(#username: String, password: String, completion: Result<Void, NSError> -> ()) {
        if authorizeSuccess {
            completion(Result(value: ()))
        } else {
            completion(Result(error: testError))
        }
    }
    
    override func requestAccessToken(#grantType: String, parameters: [String : String], completion: Result<Void, NSError> -> ()) {
        if authorizeSuccess {
            completion(Result(value: ()))
        } else {
            completion(Result(error: testError))
        }
    }
    
    override func authenticateRequest(request: NSURLRequest, completion: Result<NSURLRequest, NSError> -> ()) {
        if requestSuccess {
            completion(Result(value: testRequest))
        } else {
            completion(Result(error: testError))
        }
    }
    
}

class ReactiveHeimdallSpec: QuickSpec {
    override func spec() {

        var heimdall: MockHeimdall!
        
        beforeEach {
            heimdall = MockHeimdall(tokenURL: NSURL(string: "http://rheinfabrik.de/token")!)
        }

        describe("-requestAccessToken(username:password:)") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = true
                }
                
                it("sends Void") {
                    waitUntil { done in
                        let signalProducer = heimdall.requestAccessToken(username: "foo", password: "bar")
                        signalProducer.start(next: { value in
                            done()
                        })
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signalProducer = heimdall.requestAccessToken(username: "foo", password: "bar")
                        signalProducer.start(completed: {
                            done()
                        })
                    }
                }
                
            }
            
            context("when the completion block sends a failure result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = false
                }
                
                it("sends the error") {
                    waitUntil { done in
                        let signalProducer = heimdall.requestAccessToken(username: "foo", password: "bar")
                        signalProducer.start( error: { error in
                            expect(error).to(equal(testError))
                            done()
                        })
                    }
                }
                
            }
            
        }

        describe("-requestAccessToken(grantType:parameters:)") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = true
                }
                
                it("sends Void") {
                    waitUntil { done in
                        let signalProducer = heimdall.requestAccessToken(grantType:"foo", parameters:["code": "bar"])
                        signalProducer.start(next: { value in
                            done()
                        })
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signalProducer = heimdall.requestAccessToken(grantType:"foo", parameters:["code": "bar"])
                        signalProducer.start(completed: {
                            done()
                        })
                    }
                }
                
            }
            
            context("when the completion block sends a failure result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = false
                }
                
                it("sends the error") {
                    waitUntil { done in
                        let signalProducer = heimdall.requestAccessToken(grantType:"foo", parameters:["code": "bar"])
                        signalProducer.start( error: { error in
                            expect(error).to(equal(testError))
                            done()
                        })
                    }
                }
                
            }
            
        }

        describe ("-authenticateRequest") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.requestSuccess = true
                }
                
                it("sends the result value") {
                    waitUntil { done in
                        let signalProducer = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signalProducer.start(next: { value in
                            expect(value).to(equal(testRequest))
                            done()
                        })
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signalProducer = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signalProducer.start(completed: {
                            done()
                        })
                    }
                }
                
            }
            
            context("when the completion block sends a failure result") {
                
                beforeEach {
                    heimdall.requestSuccess = false
                }
                
                it("sends the error") {
                    waitUntil { done in
                        let signalProducer = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signalProducer.start(error: { error in
                            expect(error).to(equal(testError))
                            done()
                        })
                    }
                }
                
            }
            
        }
        
        describe("-RH_requestAccessToken(username:password:)") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = true
                }
                
                it("sends a RACUnit") {
                    waitUntil { done in
                        let signal = heimdall.RH_requestAccessToken(username: "foo", password: "bar")
                        signal.subscribeNext { value in
                            expect(value is RACUnit).to(beTrue())
                            done()
                        }
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signal = heimdall.RH_requestAccessToken(username: "foo", password: "bar")
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
                        let signal = heimdall.RH_requestAccessToken(username: "foo", password: "bar")
                        signal.subscribeError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
                    }
                }
                
            }
            
        }

        describe("-RH_requestAccessToken(grantType:parameters:)") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.authorizeSuccess = true
                }
                
                it("sends a RACUnit") {
                    waitUntil { done in
                        let signal = heimdall.RH_requestAccessToken(grantType:"foo", parameters:["code": "bar"])
                        signal.subscribeNext { value in
                            expect(value is RACUnit).to(beTrue())
                            done()
                        }
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signal = heimdall.RH_requestAccessToken(grantType:"foo", parameters:["code": "bar"])
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
                        let signal = heimdall.RH_requestAccessToken(grantType:"foo", parameters:["code": "bar"])
                        signal.subscribeError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
                    }
                }
                
            }
            
        }
        
        describe ("-RH_authenticateRequest") {
            
            context("when the completion block sends a success result") {
                
                beforeEach {
                    heimdall.requestSuccess = true
                }
                
                it("sends the result value") {
                    waitUntil { done in
                        let signal = heimdall.RH_authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        signal.subscribeNext { value in
                            expect(value as? NSURLRequest).to(equal(testRequest))
                            done()
                        }
                    }
                }
                
                it("completes") {
                    waitUntil { done in
                        let signal = heimdall.RH_authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
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
                        let signal = heimdall.RH_authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
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
