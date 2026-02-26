import Vapor

struct ReceiptsController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {
        routes.group("receipts") { receipts in
            receipts.grouped("process").post(use: processReceipt)
            
            receipts.group(":id") { receipt in
                receipt.grouped("points").get(use: getReceiptPoints)
            }
        }
    }

    func processReceipt(req: Request) async throws -> StoredReceiptResponse {
        let receipt = try req.content.decode(Receipt.self)
        let newUuid = UUID()
        req.application.receiptStore?.receipts.updateValue(receipt, forKey: newUuid)
        return StoredReceiptResponse(id: newUuid.uuidString.lowercased())
    }

    func getReceiptPoints(req: Request) async throws -> GetPointsResponse {
        guard let idParam = req.parameters.get("id"), let id = UUID(uuidString: idParam) else {
            throw Abort(.badRequest, reason: "Missing or invalid receipt ID")
        }
        if let receipt = req.application.receiptStore?.receipts[id] {
            return GetPointsResponse(points: receipt.getPoints())
        } else {
            throw Abort(.notFound)
        }
    }
}
