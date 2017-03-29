//
//  EnvoyTests.swift
//  AirHelp
//
//  Created by Pawel Dudek on {TODAY}.
//  Copyright © 2017 AirHelp. All rights reserved.
//

import Foundation
import XCTest
import Envoy

protocol AuthenticationObserver {

    func didAuthenticate()

    func didFailToAuthenticate(with error: NSError)

}

class NotificationPoster {

}

class NotificationObserver: AuthenticationObserver {

    var didCallDidAuthenticate = false
    var didCallDidFail = false

    var errorFromDidFail: NSError?

    func didAuthenticate() {
        didCallDidAuthenticate = true
    }

    func didFailToAuthenticate(with error: NSError) {
        didCallDidFail = true
        errorFromDidFail = error
    }
}

class EnvoyTests: XCTestCase {

    func testPostNotification() {
        let observer = NotificationObserver()

        let poster = NotificationPoster()

        Envoy.register(AuthenticationObserver.self, observer: observer, object: poster)

        Envoy.notify(AuthenticationObserver.self, object: poster) { observer in
            observer.didAuthenticate()
        }

        XCTAssertTrue(observer.didCallDidAuthenticate, "Expected observer to receive notification")
    }

    func testTwoObjectsPostNotification() {
        let observer1 = NotificationObserver()
        let observer2 = NotificationObserver()

        let poster = NotificationPoster()

        Envoy.register(AuthenticationObserver.self, observer: observer1, object: poster)
        Envoy.register(AuthenticationObserver.self, observer: observer2, object: poster)

        Envoy.notify(AuthenticationObserver.self, object: poster) { observer in
            observer.didAuthenticate()
        }

        XCTAssertTrue(observer1.didCallDidAuthenticate, "Expected observer for posting object to receive notification")
        XCTAssertTrue(observer2.didCallDidAuthenticate, "Expected observer for posting object to receive notification")
    }

    func testTwoObjectsDifferentPosterPostNotification() {
        let observer1 = NotificationObserver()
        let observer2 = NotificationObserver()

        let poster1 = NotificationPoster()
        let poster2 = NotificationPoster()

        Envoy.register(AuthenticationObserver.self, observer: observer1, object: poster1)
        Envoy.register(AuthenticationObserver.self, observer: observer2, object: poster2)


        Envoy.notify(AuthenticationObserver.self, object: poster1) { observer in
            observer.didAuthenticate()
        }

        XCTAssertTrue(observer1.didCallDidAuthenticate, "Expected observer for posting object to receive notification")
        XCTAssertFalse(observer2.didCallDidAuthenticate, "Expected observer for non-posting object to not receive notification")
    }

    func testParameterPostNotification() {
        let observer = NotificationObserver()

        let poster = NotificationPoster()

        Envoy.register(AuthenticationObserver.self, observer: observer, object: poster)

        Envoy.notify(AuthenticationObserver.self, object: poster) { observer in
            observer.didFailToAuthenticate(with: NSError(domain: "Fixture Domain", code: 42))
        }

        XCTAssertTrue(observer.didCallDidFail, "Expected observer for posting object to receive notification")
        XCTAssertEqual(observer.errorFromDidFail, NSError(domain: "Fixture Domain", code: 42), "Expected Observer to receive error parameter")

    }

    func testTwoObjectsAndParameterPostNotification() {
        let observer1 = NotificationObserver()
        let observer2 = NotificationObserver()

        let poster1 = NotificationPoster()
        let poster2 = NotificationPoster()

        Envoy.register(AuthenticationObserver.self, observer: observer1, object: poster1)
        Envoy.register(AuthenticationObserver.self, observer: observer2, object: poster2)


        Envoy.notify(AuthenticationObserver.self, object: poster1) { observer in
            observer.didFailToAuthenticate(with: NSError(domain: "Fixture Domain", code: 42))
        }

        XCTAssertTrue(observer1.didCallDidFail, "Expected observer for posting object to receive notification")
        XCTAssertEqual(observer1.errorFromDidFail, NSError(domain: "Fixture Domain", code: 42), "Expected Observer to receive error parameter")
    }
}

#if os(Linux)

extension EnvoyTests {
    static var allTests: [(String, (EnvoyTests) -> () throws -> Void)] {
        return [
                ("testExample", testPostNotification),
                ("testTwoObjectsPostNotification", testTwoObjectsPostNotification),
                ("testTwoObjectsDifferentPosterPostNotification", testTwoObjectsDifferentPosterPostNotification),
                ("testParameterPostNotification", testParameterPostNotification),
                ("testTwoObjectsAndParameterPostNotification", testTwoObjectsAndParameterPostNotification),
        ]
    }
}

#endif
