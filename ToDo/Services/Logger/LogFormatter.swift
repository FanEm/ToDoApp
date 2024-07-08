//
//  LogFormatter.swift
//  ToDo
//
//  Created by Artem Novikov on 08.07.2024.
//

import CocoaLumberjackSwift

// MARK: - LogFormatter
final class LogFormatter: NSObject, DDLogFormatter {

    private let dateFormatter: DateFormatter

    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        super.init()
    }

    func format(message logMessage: DDLogMessage) -> String? {
        let dateAndTime = dateFormatter.string(from: logMessage.timestamp)
        let logLevel: String = switch logMessage.flag {
        case .error: "ERROR"
        case .warning: "WARN"
        case .info: "INFO"
        case .debug: "DEBUG"
        case .verbose: "VERBOSE"
        default: "UNKNOWN"
        }

        let formattedMessage = "\(dateAndTime) [\(logLevel)] " +
        "[\(logMessage.fileName):\(logMessage.line)] \(logMessage.message)"
        return formattedMessage
    }

}
