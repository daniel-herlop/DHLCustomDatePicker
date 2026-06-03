# DHLCustomDatePicker

Date/hour selector.

![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![Platform](https://img.shields.io/badge/iOS-14%2B-blue)

## Preview
![Screenshot](docs/screenshot1.png)

![Screenshot](docs/screenshot2.png)

![Screenshot](docs/screenshot3.png)

## Installation

### CocoaPods

```ruby
pod 'DHLCustomDatePicker'
```

## Quick Start

### UIKit

```swift
@IBOutlet weak var myDatePicker: DHLCustomDatePicker!

myDatePicker.setUp(parent: self, type: .date, datePickedAction: { selectedDate in
            
})

myDatePicker.setDate(Date())
```
