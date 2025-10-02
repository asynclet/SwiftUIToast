import SwiftUI
import Combine
import OrderedCollections

extension ToastModel {
    static var error: ToastModel { ToastModel(config: .default, type: .error) }
    static var info: ToastModel { ToastModel(config: .default, type: .info) }
    static var warning: ToastModel { ToastModel(config: .default, type: .warning) }
    static var snackbar: ToastModel { ToastModel(config: .default, type: .snackBar) }
    static var none: ToastModel { ToastModel(config: .default, type: .none) }
}

public struct ToastViewModifier: ViewModifier {
    // MARK: - Properties
    
    @EnvironmentObject var store: ToastStore
    @State private var activeToasts: [ToastModel] = []

    public func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(0)
            
            ForEach(activeToasts, id: \.config.id) { toast in
                ToastOverlayView(
                    model: toast
                )
                .onTapGesture {
                    Task { @MainActor in
                        await store.dismiss(toast.config.id)
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: toast.config.position == .bottom ? .bottom : .top),
                        removal: .move(edge: toast.config.position == .bottom ? .bottom : .top)
                    )
                )
                .environmentObject(store)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: activeToasts)
        .onReceive(store.$activeToasts) { newValue in
            activeToasts = newValue.compactMap { toastID in
                store.activeToastModels[toastID]
            }
        }
    }
}

public extension View {
    func toast() -> some View {
        modifier(ToastViewModifier())
    }
}
