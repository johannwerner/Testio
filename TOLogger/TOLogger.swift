import Foundation

public enum LoggerState {
    case showAll
    case showOnlyError
    case showOnlyWarnings
    case showWarningsErrors
}

public class Logger {
    private init() { }
    
    /// Use this to show all, or hide some warnings.
    /// - showAll - Shows all prints
    /// - showOnlyError - Shows only error warnings
    /// - showOnlyWarnings - Shows only warnings
    /// - showWarningsErrors - shows both erros and warnings but hides everything else
    public static var loggerState: LoggerState = .showAll {
        // Warning user that they may not see all logs.
        didSet {
            switch loggerState {
            case .showAll: break
            case .showOnlyError:
                Logger.printString("🪵 Only showing logs for errors")
            case .showOnlyWarnings:
                Logger.printString("🪵 Only showing logs for warnings")
            case .showWarningsErrors:
                Logger.printString("🪵 Only showing logs for erros and warnings")
            }
        }
    }
    
    /// prints the error.localizedDescription) in console with a 🛑 emoji only in debug configuration.
    public static func log(_ error: NSError, file: String = #file, line: Int = #line, column: Int = #column) {
        if showErrors {
            logError(error.localizedDescription, file: file, line: line, column: column)
        }
    }
    
    /// prints the error.localizedDescription) in console with a 🛑 emoji only in debug configuration.
    public static func log(_ error: Error, file: String = #file, line: Int = #line, column: Int = #column) {
        if showErrors {
            logError(error.localizedDescription, file: file, line: line, column: column)
        }
    }
    
    /// prints the string only in debug configuration.
    /// - shown when loggerState = .showAll
    public static func log(_ string: String, file: String = #file, line: Int = #line, column: Int = #column) {
        if case .showAll = loggerState {
            printString("\(string)", file: file, line: line, column: column)
        }
    }
    
    /// prints items only in debug configuration.
    /// - shown when loggerState = .showAll
    public static func log(_ items: Any, file: String = #file, line: Int = #line, column: Int = #column) {
        if case .showAll = loggerState {
            #if targetEnvironment(simulator)
            print("\(items)", separator: " ", terminator: "")
            print(" @ \(fileName(from: file))", "\(line):\(column)")
            #elseif DEBUG
            print("\(items)", separator: " ", terminator: "")
            print(" @ \(fileName(from: file))", "\(line):\(column)")
            #endif
        }
    }
    
    private static func printString(_ string: String, file: String = #file, line: Int = #line, column: Int = #column) {
        #if targetEnvironment(simulator)
        print("\(string)", "@ \(fileName(from: file))", "\(line):\(column)")
        #elseif DEBUG
        print("\(string)", "@ \(fileName(from: file))", "\(line):\(column)")
        #endif
    }
    
    /// prints the string with a 🛑 emoji only in debug configuration.
    /// - shown when loggerState = .showAll, .showOnlyError, showWarningsErrors
    public static func logError(_ string: String, file: String = #file, line: Int = #line, column: Int = #column) {
        if showErrors {
            printString("🛑 \(string)", file: file, line: line, column: column)
        }
    }
    
    /// prints the string with a ⚠️ emoji only in debug configuration.
    /// - shown when loggerState = .showAll, .showOnlyWarnings, showWarningsErrors
    public static func logWarning(_ string: String, file: String = #file, line: Int = #line, column: Int = #column) {
        if showWarnings {
            printString("⚠️ \(string)", file: file, line: line, column: column)
        }
    }
}

private extension Logger {
    static var showErrors: Bool {
        switch loggerState {
        case .showAll, .showWarningsErrors, .showOnlyError:
            return true
        case .showOnlyWarnings:
            return false
        }
    }
    
    static var showWarnings: Bool {
        switch loggerState {
        case .showAll, .showWarningsErrors, .showOnlyWarnings:
            return true
        case .showOnlyError:
            return false
        }
    }
    
    static func fileName(from string: String) -> String {
        String(string.split(separator: "/").last ?? "")
    }
}
