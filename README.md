# Envoy

[![Version](https://img.shields.io/cocoapods/v/Envoy.svg?style=flat)](http://cocoapods.org/pods/Envoy)
[![Platform](https://img.shields.io/cocoapods/p/Envoy.svg?style=flat)](http://cocoapods.org/pods/Envoy)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)](https://github.com/CocoaPods/CocoaPods)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)]()
[![Public Yes](https://img.shields.io/badge/Public-yes-green.svg?style=flat)]()

Envoy is a protocol-oriented thread-safe replacement of `NSNotificationCenter`. At AirHelp we believe that in most cases using `NSNotificationCenter` is an anti-pattern ([many words](https://davidnix.io/post/stop-using-nsnotificationcenter/) [have been said](http://blog.jaredsinclair.com/post/136408895215/nsnotificationcenter-is-probably-an-anti-pattern) on this subject).

Moreover `NSNotificationCenter` API feels antique in the Swift world, with string-based event registration, selectors and requirement of `@objc` methods.

So we decided to build a replacement that will give us a solution similar to `NSNotificationCenter` but without the way-too-loose coupling and with a much nicer Swift API.

Thus Envoy was born.

# Usage

In order to register for notifications for given object and given protocol you need to call:

```swift
Envoy.register(AuthenticationObserver.self, observer: observer, object: poster)
```

To post notification you need to call

```swift
Envoy.notify(AuthenticationObserver.self, object: poster) { observer in
    observer.didAuthenticate()
}
```

And that's it! Envoy takes care of routing to appropriate objects based on passed in protocol and object you wish to observe. Moreover it automatically handles weak references, there's no need to unregister upon deinit.

## Installation

### Cocoapods

Envoy is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile against your test target:

```ruby
pod "Envoy"
```

### Carthage

You can also use [Carthage](https://github.com/Carthage/Carthage) for installing Envoy.
Simply add it to your Cartfile:

```
github "Airhelp/Envoy"
```

and then link it with your test target.

### Swift Package Manager

Envoy is also available via Swift Package Manager. You can add it by defining a dependency:

```swift
.Package(url: "https://github.com/airhelp/envoy.git", majorVersion: 1),
```

## Authors

Envoy is an AirHelp open source project, designed and implemented by

* Pawel Dudek, [@eldudi](http://twitter.com/eldudi), pawel@dudek.mobi
* Pawel Kozielecki, [@pawelkozielecki](https://twitter.com/pawelkozielecki), pawel.kozielecki@airhelp.com

## License

*Envoy* is available under the MIT license. See the LICENSE file for more info.
