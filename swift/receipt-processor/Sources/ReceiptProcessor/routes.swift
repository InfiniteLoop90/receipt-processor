import Vapor

func routes(_ app: Application) throws {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    let localTimeStr = dateFormatter.string(from: now)

    app.get { req async throws in
        try await req.view.render("index", [
            "title": "Receipt Processor Home Page (Swift + Vapor)",
            "currentTimestamp": localTimeStr
        ])
    }

    try app.register(collection: ReceiptsController())
}
