import Vapor

/**
 Adding addition attributes to Vapor's Application class as a cheap way to have global data storage.
 */
extension Application {
    var receiptStore: ReceiptStore? {
        get {
            self.storage[ReceiptStoreKey.self]
        }
        set {
            self.storage[ReceiptStoreKey.self] = newValue
        }
    }
}
