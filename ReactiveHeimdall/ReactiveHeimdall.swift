//
//  ReactiveHeimdall.swift
//  ReactiveHeimdall
//
//  Created by Tim Brückmann on 12.02.15.
//  Copyright (c) 2015 B264 GmbH. All rights reserved.
//

import Foundation
import Heimdall
import ReactiveCocoa

extension Heimdall {
    
    public func requestAccessToken(username: String, password: String) -> RACSignal {
        return RACSignal.createSignal { subscriber in
            self.requestAccessToken(username, password: password) { result in
                switch result {
                case .Success:
                    subscriber.sendCompleted()
                case .Failure(let error):
                    subscriber.sendError(error.unbox)
                }
            }
            return nil
        }
    }
    
    public func authenticateRequest(request: NSURLRequest) -> RACSignal {
        return RACSignal.createSignal { subscriber in
            self.authenticateRequest(request) { result in
                switch result {
                case .Success(let value):
                    subscriber.sendNext(value.unbox)
                    subscriber.sendCompleted()
                case .Failure(let error):
                    subscriber.sendError(error.unbox)
                }
            }
            return nil
        }
    }
    
}
