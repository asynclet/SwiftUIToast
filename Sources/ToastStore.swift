import Foundation
import Combine
import SwiftUI
import OrderedCollections

@MainActor
public final class ToastStore: ObservableObject {
    // MARK: - Properties
    
    private let localManager = ToastManager()
    private var cancellable: AnyCancellable?
    public private(set) var activeToastModels: [String: ToastModel] = [:]
    
    @Published public private(set) var activeToasts: [String] = []
    
    // MARK: - Init
    
    public init() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            for await events in await localManager.getActiveToasts() {
                self.activeToasts = events
            }
        }
    }
    
    // MARK: - Internal Methods
    
    public func enqueue(config: ToastConfig, type: ToastType) async {
        await MainActor.run {
            let toastModel = ToastModel(config: config, type: type)
            activeToastModels[config.id] = toastModel
        }
        
        await localManager.enqueue(toast: config)
    }
    
    public func dismissAll() async {
        await localManager.dismissAll()
    }
    
    public func dismiss(_ id: String) async {
        await localManager.dismiss(id)
    }
}
