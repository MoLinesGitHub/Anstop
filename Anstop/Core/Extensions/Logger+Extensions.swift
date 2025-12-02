import OSLog

extension Logger {
    private static let subsystem = "com.molines.Anstop"
    
    static let ui = Logger(subsystem: subsystem, category: "ui")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let database = Logger(subsystem: subsystem, category: "database")
    static let analytics = Logger(subsystem: subsystem, category: "analytics")
    static let purchases = Logger(subsystem: subsystem, category: "purchases")
}
