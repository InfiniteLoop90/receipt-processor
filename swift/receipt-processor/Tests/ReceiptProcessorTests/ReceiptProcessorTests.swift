@testable import ReceiptProcessor
import VaporTesting
import Testing

@Suite("App Tests")
struct ReceiptProcessorTests {
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }

    @Test("Test Basic POST Example")
    func basicPostExample() async throws {
        let newReceipt = Receipt(
            retailer: "Target",
            purchaseDate: "2022-01-01",
            purchaseTime: "13:01",
            items: [
                Item(
                    shortDescription: "Mountain Dew 12PK",
                    price: Decimal(string: "6.49")!
                )
            ]
        )

        try await withApp(configure: configure) { app in
            try await app.testing().test(.POST, "receipts/process", beforeRequest: { req in
                // Encoding shouldn't fail here; make non-throwing for the closure signature
                try? req.content.encode(newReceipt)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let stored = try res.content.decode(StoredReceiptResponse.self)
                #expect(stored.id.isEmpty == false)
            })
        }
    }
}
