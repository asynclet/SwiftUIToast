# SwiftUIToast

A modern, Swift Concurrency-based toast notification library for SwiftUI.

## Features

- 🚀 **Swift Concurrency** - Built with modern async/await
- 🎯 **Actor-based** - Thread-safe with no race conditions
- 📱 **SwiftUI Native** - Designed specifically for SwiftUI
- 🎨 **Customizable** - Multiple toast types and positions
- ⚡ **Performance** - Efficient AsyncStream notifications
- 🔄 **Multiple Policies** - Queue, Overlay, and Force display modes

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SwiftUIToast.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

## Quick Start

```swift
import SwiftUI
import SwiftUIToast

struct ContentView: View {
    @StateObject private var toastStore = ToastStore()
    
    var body: some View {
        VStack {
            Button("Show Toast") {
                Task {
                    await toastStore.enqueue(config: .default, type: .error)
                }
            }
        }
        .environmentObject(toastStore)
        .toast()
    }
}
```

## Example App

Check the `Example/` folder for a complete iOS app demonstrating all features:

- Queue policy toasts
- Overlay policy toasts  
- Force policy toasts
- Manual dismissal
- Different toast types

To run the example:
1. Create a new iOS project in Xcode
2. Add SwiftUIToast as a local package dependency
3. Copy the files from `Example/` folder
4. Run the project

## Toast Policies

### Queue Policy (Default)
Toasts are displayed one at a time in sequence.

### Overlay Policy
Multiple toasts can be displayed simultaneously.

### Force Policy
Replaces all existing toasts with the new one.

## Toast Types

- `.error` - Error notifications
- `.warning` - Warning notifications  
- `.info` - Information notifications
- `.snackBar` - Snackbar style notifications

## Requirements

- iOS 17.0+
- macOS 14.0+
- watchOS 10.0+
- tvOS 17.0+
- Swift 6.0+

## License

MIT License - see LICENSE file for details.
