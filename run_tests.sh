#!/bin/bash

xcodebuild test -project "Envoy.xcodeproj" -scheme "Envoy-macOS" | xcpretty --test
xcodebuild test -project "Envoy.xcodeproj" -scheme "Envoy-iOS" -destination "name=iPad Air,OS=10.2" | xcpretty --test
xcodebuild test -project "Envoy.xcodeproj" -scheme "Envoy-tvOS" -destination "name=Apple TV 1080p" | xcpretty --test
xcodebuild build -project "Envoy.xcodeproj" -scheme "Envoy-watchOS" | xcpretty --test
