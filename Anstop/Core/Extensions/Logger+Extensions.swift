import OSLog

extension Logger {
    nonisolated(unsafe) static let ui = Logger(subsystem: "com.molinesdesigns.Anstop", category: "ui")
    nonisolated(unsafe) static let network = Logger(subsystem: "com.molinesdesigns.Anstop", category: "network")
    nonisolated(unsafe) static let database = Logger(subsystem: "com.molinesdesigns.Anstop", category: "database")
    nonisolated(unsafe) static let analytics = Logger(subsystem: "com.molinesdesigns.Anstop", category: "analytics")
    nonisolated(unsafe) static let purchases = Logger(subsystem: "com.molinesdesigns.Anstop", category: "purchases")
}
