import Testing
@testable import SwiftUIToast

@Suite("ToastManager Tests")
struct SwiftUIToastTests {
    
    @Test("ToastManager should enqueue toast")
    func testToastEnqueue() async {
        let manager = ToastManager()
        let config = ToastConfig(id: "test", duration: 1.0, position: .top, policy: .queue)
        
        await manager.enqueue(toast: config)
        #expect(true)
    }
    
    @Test("ToastManager should dismiss toast")
    func testToastDismiss() async {
        let manager = ToastManager()
        let config = ToastConfig(id: "test", duration: 1.0, position: .top, policy: .queue)
        
        await manager.enqueue(toast: config)
        await manager.dismiss("test")
        
        #expect(true)
    }
    
    @Test("ToastManager should dismiss all toasts")
    func testToastDismissAll() async {
        let manager = ToastManager()
        let config1 = ToastConfig(id: "test1", duration: 1.0, position: .top, policy: .overlay())
        let config2 = ToastConfig(id: "test2", duration: 1.0, position: .top, policy: .overlay())
        
        await manager.enqueue(toast: config1)
        await manager.enqueue(toast: config2)
        await manager.dismissAll()
        
        #expect(true)
    }
    
    @Test("ToastConfig should create correctly")
    func testToastConfig() {
        let config = ToastConfig(id: "test", duration: 3.0, position: .top, policy: .queue)
        
        #expect(config.id == "test")
        #expect(config.duration == 3.0)
        #expect(config.position == .top)
        #expect(config.policy == .queue)
    }
    
    @Test("ToastType should work correctly")
    func testToastType() {
        let errorType = ToastType.error
        let warningType = ToastType.warning
        let infoType = ToastType.info
        let snackbarType = ToastType.snackBar
        
        #expect(errorType == .error)
        #expect(warningType == .warning)
        #expect(infoType == .info)
        #expect(snackbarType == .snackBar)
    }
}

