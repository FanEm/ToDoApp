//
//  Logger.swift
//  ToDo
//
//  Created by Artem Novikov on 08.07.2024.
//

import CocoaLumberjackSwift

// MARK: - Logger
struct Logger {

    static func setup() {
        let logFormatter = LogFormatter()
        let osLogger = DDOSLogger.sharedInstance
        osLogger.logFormatter = logFormatter
        DDLog.add(osLogger)

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    static func verbose(
        _ message: DDLogMessageFormat,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        DDLogVerbose(message, file: file, function: function, line: line)
    }

    static func debug(
        _ message: DDLogMessageFormat,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        DDLogDebug(message, file: file, function: function, line: line)
    }

    static func info(
        _ message: DDLogMessageFormat,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        DDLogInfo(message, file: file, function: function, line: line)
    }

    static func warn(
        _ message: DDLogMessageFormat,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        DDLogWarn(message, file: file, function: function, line: line)
    }

    static func error(
        _ message: DDLogMessageFormat,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        DDLogError(message, file: file, function: function, line: line)
    }

}
