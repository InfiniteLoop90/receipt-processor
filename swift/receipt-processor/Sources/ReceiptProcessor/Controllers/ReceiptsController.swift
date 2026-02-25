import Vapor

struct ReceiptsController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let receipts = routes.grouped("receipts", "process")
        receipts.post(use: create)

        receipts.group(":id", "points") { receipt in
            receipt.get(use: show)
        }
    }

    func create(req: Request) async throws -> StoredReceiptResponse {
        let receipt = try req.content.decode(Receipt.self)
        let newUuid = UUID()
        req.application.receiptStore?.receipts.updateValue(receipt, forKey: newUuid)
        return StoredReceiptResponse(id: newUuid)
    }

    func show(req: Request) async throws -> Receipt {
        guard let idParam = req.parameters.get("id"), let id = UUID(uuidString: idParam) else {
            throw Abort(.badRequest, reason: "Missing or invalid receipt id")
        }
        if let receipt = req.application.receiptStore?.receipts[id] {
            return receipt
        } else {
            throw Abort(.notFound)
        }
    }
}
