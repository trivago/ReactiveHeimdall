import Foundation
import Heimdall
import ReactiveCocoa

extension Heimdall {
    
    /// Requests an access token with the resource owner's password credentials.
    ///
    /// :param: username The resource owner's username.
    /// :param: password The resource owner's password.
    ///
    /// :returns: A SignalProducer that sends a `RACUnit` and completes when the
    ///     request finishes successfully or sends an error of the request
    ///     finishes with an error.
    public func requestAccessToken(username: String, password: String) -> SignalProducer<RACUnit, NSError> {
        return SignalProducer() { sink, disposable in
            self.requestAccessToken(username: username, password: password) { result in
                switch result {
                case .Success:
                    sendNext(sink, RACUnit())
                    sendCompleted(sink)
                case .Failure(let error):
                    sendError(sink, error.unbox)
                }
            }
        }
    }
    
    /// Requests an access token with the given grant type.
    ///
    /// :param: grantType The name of the grant type
    /// :param: parameters The required parameters for the custom grant type
    ///
    /// :returns: A signal that sends a `RACUnit` and completes when the
    ///     request finishes successfully or sends an error if the request
    ///     finishes with an error.
    public func requestAccessToken(#grantType: String, parameters: NSDictionary) -> SignalProducer<RACUnit, NSError> {
        return SignalProducer() { sink, disposable in
            self.requestAccessToken(grantType: grantType, parameters:parameters as! [String: String]) { result in
                switch result {
                case .Success:
                    sendNext(sink, RACUnit())
                    sendCompleted(sink)
                case .Failure(let error):
                    sendError(sink, error.unbox)
                }
            }
        }
    }
    
    /// Alters the given request by adding authentication, if possible.
    ///
    /// In case of an expired access token and the presence of a refresh token,
    /// automatically tries to refresh the access token.
    ///
    /// **Note:** If the access token must be refreshed, network I/O is
    ///     performed.
    ///
    /// :param: request An unauthenticated NSURLRequest.
    ///
    /// :returns: A SignalProducer that sends the authenticated request on success or
    ///     an error when the request could not be authenticated.
    public func authenticateRequest(request: NSURLRequest) -> SignalProducer<NSURLRequest, NSError> {
        return SignalProducer { sink, disposable in
            self.authenticateRequest(request) { result in
                switch result {
                case .Success(let value):
                    sendNext(sink, value.unbox)
                    sendCompleted(sink)
                case .Failure(let error):
                    sendError(sink, error.unbox)
                }
            }
        }
    }
    
    // MARK: Objective-C compatibility

    /// Requests an access token with the resource owner's password credentials.
    ///
    /// :param: username The resource owner's username.
    /// :param: password The resource owner's password.
    ///
    /// :returns: A signal that sends a `RACUnit` and completes when the
    ///     request finishes successfully or sends an error of the request
    ///     finishes with an error.
    @objc
    public func RH_requestAccessToken(username: String, password: String) -> RACSignal {
        return toRACSignal(requestAccessToken(username, password: password))
    }
    
    /// Requests an access token with the given grant type.
    ///
    /// :param: grantType The name of the grant type
    /// :param: parameters The required parameters for the custom grant type
    ///
    /// :returns: A signal that sends a `RACUnit` and completes when the
    ///     request finishes successfully or sends an error if the request
    ///     finishes with an error.
    @objc
    public func RH_requestAccessToken(#grantType: String, parameters: NSDictionary) -> RACSignal {
        return toRACSignal(requestAccessToken(grantType: grantType, parameters:parameters))
    }

    /// Alters the given request by adding authentication, if possible.
    ///
    /// In case of an expired access token and the presence of a refresh token,
    /// automatically tries to refresh the access token.
    ///
    /// **Note:** If the access token must be refreshed, network I/O is
    ///     performed.
    ///
    /// :param: request An unauthenticated NSURLRequest.
    ///
    /// :returns: A SignalProducer that sends the authenticated request on success or
    ///     an error when the request could not be authenticated.
    @objc
    public func RH_authenticateRequest(request: NSURLRequest) -> RACSignal {
        return toRACSignal(authenticateRequest(request))
    }

}
