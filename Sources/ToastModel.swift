import SwiftUI

public struct ToastModel: Equatable, Hashable {
    let config: ToastConfig
    let type: ToastType
    
    init(
        config: ToastConfig,
        type: ToastType
    ) {
        self.config = config
        self.type = type
    }
}
