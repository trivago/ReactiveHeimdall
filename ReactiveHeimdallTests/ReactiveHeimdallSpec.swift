import Foundation
import Heimdall
import Nimble
import Quick
import ReactiveCocoa
import ReactiveHeimdall
import Result

private let testError = NSError(domain: "MockHeimdall", code: 123, userInfo: nil)
private let testRequest = NSURLRequest(URL: NSURL(string: "http://rheinfabrik.de/members")!)

private class MockHeimdall: Heimdall {
    private var authorizeSuccess = true
    private var requestSuccess = true

    private override func requestAccessToken(username username: String, password: String, completion: Result<Void, NSError> -> ()) {
        if authorizeSuccess {
            completion(Result(value: ()))
        } else {
            completion(Result(error: testError))
        }
    }

    private override func requestAccessToken(grantType grantType: String, parameters: [String: String], completion: Result<Void, NSError> -> ()) {
        if authorizeSuccess {
            completion(Result(value: ()))
        } else {
            completion(Result(error: testError))
        }
    }

    private override func authenticateRequest(request: NSURLRequest, completion: Result<NSURLRequest, NSError> -> ()) {
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
                        let producer = heimdall.requestAccessToken(username: "foo", password: "bar")
                        producer.startWithNext { value in
                            done()
                        }
                    }
                }

                it("completes") {
                    waitUntil { done in
                        let producer = heimdall.requestAccessToken(username: "foo", password: "bar")
                        producer.startWithCompleted {
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
                        let producer = heimdall.requestAccessToken(username: "foo", password: "bar")
                        producer.startWithError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
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
                        let producer = heimdall.requestAccessToken(grantType:"foo", parameters: ["code": "bar"])
                        producer.startWithNext { value in
                            done()
                        }
                    }
                }

                it("completes") {
                    waitUntil { done in
                        let producer = heimdall.requestAccessToken(grantType:"foo", parameters: ["code": "bar"])
                        producer.startWithCompleted {
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
                        let producer = heimdall.requestAccessToken(grantType:"foo", parameters: ["code": "bar"])
                        producer.startWithError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
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
                        let producer = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        producer.startWithNext { value in
                            expect(value).to(equal(testRequest))
                            done()
                        }
                    }
                }

                it("completes") {
                    waitUntil { done in
                        let producer = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        producer.startWithCompleted {
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
                        let producer = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
                        producer.startWithError { error in
                            expect(error).to(equal(testError))
                            done()
                        }
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
