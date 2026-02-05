//
//  Logger.swift
//  Pods
//
//  Created by Golan Shoval Gil on 13/01/2026.
//

import Foundation

final public class Logger {
    private init() {}

    private static func log(prefix: String, _ message: String) {
        NSLog("%@ %@", prefix, message)
    }

    public static func info(_ message: String) {
        log(prefix: "ℹ️ [GC][INFO][Sample]", message)
    }

    public static func warning(_ message: String) {
        log(prefix: "⚠️ [GC][WARNING][Sample]", message)
    }

    public static func error(_ message: String) {
        log(prefix: "❌ [GC][ERROR][Sample]", message)
    }
}
