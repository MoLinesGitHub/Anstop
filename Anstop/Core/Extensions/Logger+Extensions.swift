import OSLog

extension Logger {
    static let ui = Logger(subsystem: "com.molinesdesigns.Anstop", category: "ui")
    static let network = Logger(subsystem: "com.molinesdesigns.Anstop", category: "network")
    static let database = Logger(subsystem: "com.molinesdesigns.Anstop", category: "database")
    static let analytics = Logger(subsystem: "com.molinesdesigns.Anstop", category: "analytics")
    static let purchases = Logger(subsystem: "com.molinesdesigns.Anstop", category: "purchases")
}
