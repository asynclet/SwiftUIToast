import SwiftUI
import SwiftUIToast

struct ContentView: View {
    @EnvironmentObject var toastStore: ToastStore
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.2),
                    Color.pink.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("SwiftUIToast")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Modern Toast Library")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Queue Policy Section
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Queue Policy")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Toasts are displayed one at a time in sequence")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                GlassButton(title: "Error Toast", icon: "exclamationmark.triangle.fill", color: .red) {
                                    Task {
                                        await toastStore.enqueue(config: .default, type: .error)
                                    }
                                }
                                
                                GlassButton(title: "Warning Toast", icon: "exclamationmark.triangle.fill", color: .orange) {
                                    Task {
                                        await toastStore.enqueue(config: .default, type: .warning)
                                    }
                                }
                                
                                GlassButton(title: "Info Toast", icon: "info.circle.fill", color: .blue) {
                                    Task {
                                        await toastStore.enqueue(config: .default, type: .info)
                                    }
                                }
                                
                                GlassButton(title: "Snackbar Toast", icon: "rectangle.fill", color: .purple) {
                                    Task {
                                        await toastStore.enqueue(config: .default, type: .snackBar)
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Overlay Policy Section
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Overlay Policy")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Multiple toasts can be displayed simultaneously")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 12) {
                                GlassButton(title: "Overlay Error", icon: "exclamationmark.triangle.fill", color: .red) {
                                    Task {
                                        await toastStore.enqueue(config: ToastConfig(id: UUID().uuidString, duration: 3.0, position: .top, policy: .overlay()), type: .error)
                                    }
                                }
                                
                                GlassButton(title: "Overlay Warning", icon: "exclamationmark.triangle.fill", color: .orange) {
                                    Task {
                                        await toastStore.enqueue(config: ToastConfig(id: UUID().uuidString, duration: 3.0, position: .bottom, policy: .overlay()), type: .warning)
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Force Policy Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Force Policy")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Replaces all existing toasts with the new one")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 12) {
                                GlassButton(title: "Force Error", icon: "exclamationmark.triangle.fill", color: .red) {
                                    Task {
                                        await toastStore.enqueue(config: ToastConfig(id: UUID().uuidString, duration: 3.0, position: .top, policy: .force), type: .error)
                                    }
                                }
                                
                                GlassButton(title: "Force Warning", icon: "exclamationmark.triangle.fill", color: .orange) {
                                    Task {
                                        await toastStore.enqueue(config: ToastConfig(id: UUID().uuidString, duration: 3.0, position: .bottom, policy: .force), type: .warning)
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Controls Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Toast Controls")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 12) {
                                GlassButton(title: "Dismiss All", icon: "trash.fill", color: .red) {
                                    Task {
                                        await toastStore.dismissAll()
                                    }
                                }
                                
                                GlassButton(title: "Dismiss First", icon: "minus.circle.fill", color: .orange) {
                                    Task {
                                        if let firstToast = toastStore.activeToasts.first {
                                            await toastStore.dismiss(firstToast)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .toast()
    }
}

// MARK: - Glass Components

struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
    }
}

struct GlassButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(.plain)
    }
}
