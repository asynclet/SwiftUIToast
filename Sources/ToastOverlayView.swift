import SwiftUI
import Combine

struct ToastOverlayView: View {
    // MARK: - Properties
    
    private let model: ToastModel
    
    // MARK: - Init
    
    init(model: ToastModel) {
        self.model = model
    }
    
    var body: some View {
        model.type.content
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: model.config.position == .bottom ? .bottom : .top
            )
            .zIndex(1)
    }
}
