import Vapor

/*
   Got this idea from https://docs.vapor.codes/advanced/services/#writable
 */
struct ReceiptStoreKey: StorageKey {
    typealias Value = ReceiptStore
}
