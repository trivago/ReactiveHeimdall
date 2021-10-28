# ReactiveHeimdall

ReactiveHeimdall is a [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)-based extension to [Heimdallr.swift](https://github.com/trivago/Heimdallr.swift).

[![Build Status](https://circleci.com/gh/rheinfabrik/ReactiveHeimdall.svg?style=svg&circle-token=a683f89919f4b802dbb7e4a082f3ef09432f6c41)](https://circleci.com/gh/rheinfabrik/ReactiveHeimdall)

## Installation

Installation is possible via Carthage or CocoaPods, see below for either method:

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

1. Add ReactiveHeimdall to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

  ```
  github "rheinfabrik/ReactiveHeimdall" ~> 2.0
  ```

2. Run `carthage update` to fetch and build Heimdall and its dependencies.

3. [Make sure your application's target links against `ReactiveHeimdall.framework` and copies all relevant frameworks into its application bundle (iOS); or embeds the binaries of all relevant frameworks (Mac).](https://github.com/carthage/carthage#getting-started)

### CocoaPods

1. Add ReactiveHeimdall to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

   ```ruby
   pod 'ReactiveHeimdall', :git => 'https://github.com/rheinfabrik/ReactiveHeimdall.git', :tag => '2.0'
   ```
   
2.  Run `pod install` to fetch and build ReactiveHeimdall and its dependencies.

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
signal.subscribeError { error in
    // request could not be authorized
}
```

## About

ReactiveHeimdall was built by [Rheinfabrik](http://www.rheinfabrik.de) 🏭
