import Foundation
import Heimdall
import ReactiveCocoa

extension Heimdall {
    
    /// Requests an access token with the resource owner's password credentials.
    ///
    /// :param: username The resource owner's username.
    /// :param: password The resource owner's password.
    ///
    /// :returns: A signal that sends a `RACUnit` and completes when the
    ///     request finishes successfully or sends an error of the request
    ///     finishes with an error.
    public func requestAccessToken(username: String, password: String) -> RACSignal {
        return RACSignal.createSignal { subscriber in
            self.requestAccessToken(username: username, password: password) { result in
                switch result {
                case .Success:
                    subscriber.sendNext(RACUnit())
                    subscriber.sendCompleted()
                case .Failure(let error):
                    subscriber.sendError(error.unbox)
                }
            }
            return nil
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
    /// :returns: A signal that sends the authenticated request on success or
    ///     an error when the request could not be authenticated.
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
