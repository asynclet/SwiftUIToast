import SwiftUI

public enum ToastPosition: Hashable, Sendable {
    case top
    case bottom
}

public enum ToastPolicy: Hashable, Sendable {
    case force
    case overlay(_ max: Int = 3)
    case queue
}

public struct ToastConfig: Hashable, Sendable {
    let id: String
    let duration: TimeInterval
    let position: ToastPosition
    let policy: ToastPolicy
    
    public init(
        id: String? = nil,
        duration: TimeInterval = 3.0,
        position: ToastPosition = .top,
        policy: ToastPolicy = .queue
    ) {
        self.id = id ?? UUID().uuidString
        self.duration = duration
        self.position = position
        self.policy = policy
    }
    
    public static var `default`: ToastConfig {
        ToastConfig()
    }
    
    public static var force: ToastConfig {
        ToastConfig(policy: .force)
    }
}

public struct SuccessToastView: View {
    let message: String
    
    public var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(message)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

public struct ErrorToastView: View {
    let message: String
    
    public var body: some View {
        HStack {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
            Text(message)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

public struct WarningToastView: View {
    let message: String
    
    public var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(message)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

public struct InfoToastView: View {
    let message: String
    
    public var body: some View {
        HStack {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
            Text(message)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

public struct SnackBarView: View {
    let message: String
    let action: (() -> Void)?
    
    public var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.primary)
            Spacer()
            if let action = action {
                Button("Action") {
                    action()
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .frame(height: 48)
        .background(Color.gray)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
