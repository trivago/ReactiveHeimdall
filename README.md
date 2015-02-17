# ReactiveHeimdall

ReactiveHeimdall is a [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)-based extension to [Heimdall.swift](https://github.com/rheinfabrik/Heimdall.swift).

## Usage

When requesting an access token the signal completes on success
```swift
let signal = heimdall.requestAccessToken("foo", password: "bar")
signal.subscribeCompleted {
    // access token has been aquired
}
signal.subscribeError { error in
    // access token could not be acquired
}
```

When authenticating a request the signal sends the authenticated request and completes on success
```swift
let signal = heimdall.authenticateRequest(NSURLRequest(URL: NSURL(string: "http://www.rheinfabrik.de/foobar")!))
signal.subscribeNext { value in
    let request = value as? NSURLRequest // request is the authenticated `NSURLRequest`
}
```

## About

Heimdall was built by [Rheinfabrik](http://www.rheinfabrik.de) 🏭
