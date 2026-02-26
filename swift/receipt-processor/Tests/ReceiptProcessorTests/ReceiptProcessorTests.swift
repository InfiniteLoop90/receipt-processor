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

    @Test("Test First Example")
    func postAndResponseOfFirstExampleShouldReturnExpectedPoints() async throws {
        let newReceipt = Receipt(
            retailer: "Target",
            purchaseDate: "2022-01-01",
            purchaseTime: "13:01",
            items: [
                Item(
                    shortDescription: "Mountain Dew 12PK",
                    price: Decimal(string: "6.49")!
                ),
                Item(
                    shortDescription: "Emils Cheese Pizza",
                    price: Decimal(string: "12.25")!
                ),
                Item(
                    shortDescription: "Knorr Creamy Chicken",
                    price: Decimal(string: "1.26")!
                ),
                Item(
                    shortDescription: "Doritos Nacho Cheese",
                    price: Decimal(string: "3.35")!
                ),
                Item(
                    shortDescription: "   Klarbrunn 12-PK 12 FL OZ  ",
                    price: Decimal(string: "12.00")!
                )
            ],
            total: Decimal(string: "35.35")!
        )

        try await withApp(configure: configure) { app in
            try await app.testing().test(.POST, "receipts/process", beforeRequest: { req1 in
                try? req1.content.encode(newReceipt)
            }, afterResponse: { res1 async throws in
                #expect(res1.status == .ok)
                let storedReceiptResponse = try res1.content.decode(StoredReceiptResponse.self)
                #expect(storedReceiptResponse.id.isEmpty == false)


                try await app.testing().test(.GET, "receipts/\(storedReceiptResponse.id)/points", afterResponse: { res2 async throws in
                    #expect(res2.status == .ok)
                    let pointsResponse = try res2.content.decode(GetPointsResponse.self)
                    #expect(pointsResponse.points == 28)
                })
            })
        }
    }
}
