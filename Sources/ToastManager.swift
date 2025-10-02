import SwiftUI
import Combine
import OrderedCollections

protocol ToastManagerProtocol {
    func getActiveToasts() async -> AsyncStream<[String]>
    func enqueue(toast: ToastConfig) async
    func dismissAll() async
    func dismiss(_ id: String) async
}

actor ToastManager: ToastManagerProtocol {
    // MARK: – Properties
    
    private var activeToasts: [String] = []
    private var pendingQueue: [ToastConfig] = []
    private var autoDismissTasks: [String: Task<Void, Never>] = [:]
    private var continuation: AsyncStream<[String]>.Continuation?
    
    // MARK: – Public Init
    
    init() {}
    
    // MARK: – Public Methods
    
    func getActiveToasts() -> AsyncStream<[String]> {
        AsyncStream { continuation in
            self.continuation = continuation            
            continuation.yield(activeToasts)
        }
    }
    
    func enqueue(toast: ToastConfig) async {
        switch toast.policy {
        case .force:
            await dismissAll()
            await showToast(toast)
        case .overlay:
            await showToast(toast)
        case .queue:
            if activeToasts.isEmpty {
                await showToast(toast)
            } else {
                pendingQueue.append(toast)
            }
        }
    }
    
    func dismissAll() async {
        for task in autoDismissTasks.values {
            task.cancel()
        }
        autoDismissTasks.removeAll()
        
        activeToasts.removeAll()
        pendingQueue.removeAll()
        continuation?.yield(activeToasts)
    }
    
    func dismiss(_ id: String) async {
        if let index = activeToasts.firstIndex(of: id) {
            await cancelAutoDismiss(for: id)
            activeToasts.remove(at: index)
            continuation?.yield(activeToasts)
            await showNextIfNeeded()
        }
    }
    
    // MARK: - Private Methods
    
    private func showToast(_ config: ToastConfig) async {
        activeToasts.append(config.id)
        
        continuation?.yield(activeToasts)
        
        let task = Task(priority: .userInitiated) { @MainActor [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: .seconds(config.duration))
            await self.autoDismissToast(withID: config.id)
        }
        
        autoDismissTasks[config.id] = task
    }
    
    private func autoDismissToast(withID id: String) async {
        guard let task = autoDismissTasks[id], !task.isCancelled else {
            autoDismissTasks[id] = nil
            return
        }
        
        autoDismissTasks[id] = nil
        
        if let index = activeToasts.firstIndex(of: id) {
            activeToasts.remove(at: index)
            continuation?.yield(activeToasts)
            await showNextIfNeeded()
        }
    }
    
    private func cancelAutoDismiss(for id: String) async {
        if let task = autoDismissTasks[id] {
            task.cancel()
            autoDismissTasks[id] = nil
        }
    }
    
    private func showNextIfNeeded() async {
        guard activeToasts.isEmpty else { return }
        guard let nextConfig = pendingQueue.first else { return }
        
        pendingQueue.removeFirst()
        await showToast(nextConfig)
    }
}
