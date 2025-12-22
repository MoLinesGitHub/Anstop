// AppLogger.swift
import OSLog

enum AppLogger {
    static let notifications = Logger(subsystem: "app.anstop", category: "notifications")
    static let audio = Logger(subsystem: "app.anstop", category: "audio")
    static let store = Logger(subsystem: "app.anstop", category: "store")
    static let data = Logger(subsystem: "app.anstop", category: "data")
    static let app = Logger(subsystem: "app.anstop", category: "app")
}
