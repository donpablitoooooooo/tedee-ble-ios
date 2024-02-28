//
//  Configuration.swift
//  tedee example
//
//  Created by Mateusz Samosij on 28/02/2024.
//

import Foundation

enum Configuration {
    static let serialNumber = "22290402-120901"
    static let certificate = "AQEEAgECAwRl4aUqBAF/BQQAAAAABgQAAVF/BwRl3neACARnwPyACQQAACOqCgQAALXlCwgAAAGNqX27NH5BBAx3Ut+2bz4dJLqWLJIqTXqW2NuC5Wq9JRcOclVHDXqhNqNYpFqqf5JLP3ZiCLbUL7LvMCzc6E7g20D8RhYsB/p/RzBFAiEA89Hx9Q3/ae0La7zoCKSp9/Yk+FkErD5q7AVszDkp+3wCIDGpU0sZIGCTrY6d8hAthb16wWSSFByWEzFZq50xH1mT"
    static let expiration = "2024-03-01T09:51:38.370937Z"
    static let devicePublicKey = "BDEagkFL2rYF28ftDhUPW6yxOysss4Yd/naSdZisc6LEoniR/yiGnOs9SH/pie1m9saUO3NQIenzjRlsOrWKFCQ="
    static let mobilePublicKey = "BAx3Ut+2bz4dJLqWLJIqTXqW2NuC5Wq9JRcOclVHDXqhNqNYpFqqf5JLP3ZiCLbUL7LvMCzc6E7g20D8RhYsB/o="
}

extension Configuration {
    static var expirationDate: Date = {
        guard let expirationDate = Date.date(from: "2024-03-01T09:51:38.370937Z",
                                             format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'", isUTC: true) else {
            fatalError("Invalid expiration date format")
        }
        
        return expirationDate
    }()
}

extension Date {
    static var dF = DateFormatter()
    
    static func date(from string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss", isUTC: Bool = false, locale: Locale? = nil) -> Date? {
        dF.dateFormat = format
        dF.locale = locale ?? Locale(identifier: "en_US_POSIX")
        dF.timeZone = isUTC ? TimeZone(abbreviation: "UTC") : Calendar.current.timeZone
        return dF.date(from: string)
    }
}
