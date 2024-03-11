//
//  Configuration.swift
//  tedee example
//
//  Created by Mateusz Samosij on 28/02/2024.
//

import Foundation

enum Configuration {
    static let SerialNumber = "20370202-000002"
    static let Certificate = "AQECAgECAwRl8WQABAF/BQQAAAAABgQAAVF/BwRl7kmACARnz30ACQQAACOqCgQAALuDCwgAAAGODi4jFH5BBA98uLCr66YP9T9RU8HbboFOkw2fg8ePRLgWo8cRu3p25BbL7lgDqjbO2s7VOm+f45lGoYgV0DRlpuTTLDNpc+t/RzBFAiEAgxo9rLd2fAQL5jZvatqKUhDGGE8clCgCD/+Z5DE88SoCIDfRRuv1KhGafLgWoV09JHwGBBZ1DeMwLSKlxlxqAu2r"
    static let Expiration = "2024-03-13T08:29:52.2133904Z"
    static let DevicePublicKey = "BObygEK5gBxmGlfVbDkeQJCRxtTg8M7rmGOo2qX0pCTzrXlykYTWh+mrIX7r+XAcBiU9y6sCBPPDGx+qzFdQnro="
    static let MobilePublicKey = "BA98uLCr66YP9T9RU8HbboFOkw2fg8ePRLgWo8cRu3p25BbL7lgDqjbO2s7VOm+f45lGoYgV0DRlpuTTLDNpc+s="
}

extension Configuration {
    static var expirationDate: Date = {
        guard let expirationDate = Date.date(from: Expiration,
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
