@testable import ReceiptProcessor
import VaporTesting
import Testing

@Suite("Receipt Controller Tests")
struct ReceiptControllerTests {
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }

    @Test("Test Examples",
          arguments:
            zip(
                // Given input receipts
                [
                    Receipt(
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
                    ),
                    Receipt(
                        retailer: "M&M Corner Market",
                        purchaseDate: "2022-03-20",
                        purchaseTime: "14:33",
                        items: [
                            Item(
                                shortDescription: "Gatorade",
                                price: Decimal(string: "2.25")!
                            ),
                            Item(
                                shortDescription: "Gatorade",
                                price: Decimal(string: "2.25")!
                            ),
                            Item(
                                shortDescription: "Gatorade",
                                price: Decimal(string: "2.25")!
                            ),
                            Item(
                                shortDescription: "Gatorade",
                                price: Decimal(string: "2.25")!
                            )
                        ],
                        total: Decimal(string: "9.00")!
                    )
                ],
                // Expected Points
                [
                    28,
                    109
                ]
            )
    )
    func postAndResponseOfExampleShouldReturnExpectedPoints(receipt: Receipt, expectedPoints: Int) async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.POST, "receipts/process", beforeRequest: { req1 in
                try? req1.content.encode(receipt)
            }, afterResponse: { res1 async throws in
                #expect(res1.status == .ok)
                let storedReceiptResponse = try res1.content.decode(StoredReceiptResponse.self)
                let storedReceiptResponceUuid = storedReceiptResponse.id
                #expect(storedReceiptResponceUuid.isEmpty == false)
                #expect(storedReceiptResponceUuid == storedReceiptResponceUuid.lowercased(), "The UUID should be all in lowercase")

                try await app.testing().test(.GET, "receipts/\(storedReceiptResponceUuid)/points", afterResponse: { res2 async throws in
                    #expect(res2.status == .ok)
                    let pointsResponse = try res2.content.decode(GetPointsResponse.self)
                    #expect(pointsResponse.points == expectedPoints)
                })
            })
        }
    }
}
