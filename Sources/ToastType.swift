import SwiftUI

public enum ToastType: Hashable {
    case success
    case error
    case warning
    case info
    case snackBar
    case none
    
    @MainActor @ViewBuilder
    public var content: some View {
        switch self {
        case .success:
            SuccessToastView(message: "SuccessToastView")
        case .error:
            ErrorToastView(message: "ErrorToastView")
        case .warning:
            WarningToastView(message: "WarningToastView")
        case .info:
            InfoToastView(message: "InfoToastView")
        case .snackBar:
            SnackBarView(message: "SnackBarView", action: nil)
        case .none:
            Color.clear
        }
    }
}
