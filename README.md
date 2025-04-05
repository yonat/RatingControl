# RatingControl

⭐️ Fully customizable star ratings for iOS.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/RatingControl.svg)](https://img.shields.io/cocoapods/v/RatingControl.svg)
[![Platform](https://img.shields.io/cocoapods/p/RatingControl.svg?style=flat)](http://cocoapods.org/pods/RatingControl)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

<img align="center" src="Screenshots/RatingControl.png">

## Features

* Custom maximum rating value (default: 5)
* Support for decimal rating values (e.g., 3.5 stars)
* Custom images
* Custom size
* Rate using both tap and pan gestures

## Usage

### Basic Usage

Create a simple rating control with default settings:

```swift
let ratingControl = RatingControl()
ratingControl.value = 3.5 // Set initial rating
```

### Customization

Customize appearance and behavior:

```swift
let ratingControl = RatingControl()
ratingControl.maxValue = 7 // 7 stars instead of default 5
ratingControl.value = 4.5
ratingControl.spacing = 8 // Increase spacing between stars
ratingControl.tintColor = .systemOrange // Change color
ratingControl.emptyImage = UIImage(systemName: "heart")! // Custom empty image
ratingControl.image = UIImage(systemName: "heart.fill")! // Custom filled image
```

### User Interaction

Listen for rating changes:

```swift
ratingControl.addTarget(self, action: #selector(ratingChanged), for: .valueChanged)

@objc func ratingChanged(_ sender: RatingControl) {
    print("New rating: \(sender.value)")
}
```

Alternatively, disable user interaction:

```swift
ratingControl.isUserInteractionEnabled = false
```

## Installation

### CocoaPods:

```ruby
pod 'RatingControl'
```

### Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yonat/RatingControl", from: "1.0.0")
]

[swift-image]:https://img.shields.io/badge/swift-5.9-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE.txt
