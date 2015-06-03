# ReactiveHeimdall

ReactiveHeimdall is a [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)-based extension to [Heimdall.swift](https://github.com/rheinfabrik/Heimdall.swift).

[![Build Status](https://circleci.com/gh/rheinfabrik/ReactiveHeimdall.svg?style=svg&circle-token=a683f89919f4b802dbb7e4a082f3ef09432f6c41)](https://circleci.com/gh/rheinfabrik/ReactiveHeimdall)

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

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa. You can install it with [Homebrew](http://brew.sh) using the following commands:

```
$ brew update
$ brew install carthage
```

1. Add ReactiveHeimdall to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):
  ```
  github "rheinfabrik/ReactiveHeimdall" ~> 1.0
  ```

2. Run `carthage update` to actually fetch Heimdall and its dependencies.

3. On your application target's "General" settings tab, in the "Linked Frameworks and Libraries" section, add the following frameworks from the [Carthage/Build](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#carthagebuild) folder on disk:
  -  `ReactiveHeimdall.framework`

4. On your application target's "Build Phases" settings tab, click the "+" icon and choose "New Run Script Phase". Create a Run Script with the following contents:
  ```
  /usr/local/bin/carthage copy-frameworks
  ```
  and add the paths to all relevant frameworks under "Input Files":
  ```
  $(SRCROOT)/Carthage/Build/iOS/LlamaKit.framework
  $(SRCROOT)/Carthage/Build/iOS/Runes.framework
  $(SRCROOT)/Carthage/Build/iOS/Argo.framework
  $(SRCROOT)/Carthage/Build/iOS/KeychainAccess.framework
  $(SRCROOT)/Carthage/Build/iOS/Heimdall.framework
  $(SRCROOT)/Carthage/Build/iOS/ReactiveCocoa.framework
  $(SRCROOT)/Carthage/Build/iOS/ReactiveHeimdall.framework
  ```
  This script works around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) triggered by universal binaries.

## About

ReactiveHeimdall was built by [Rheinfabrik](http://www.rheinfabrik.de) 🏭
