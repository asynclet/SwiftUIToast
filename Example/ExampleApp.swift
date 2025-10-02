import SwiftUI
import SwiftUIToast

@main
struct ExampleApp: App {
    @StateObject private var toastStore = ToastStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .toast()
                .environmentObject(toastStore)
        }
    }
}
