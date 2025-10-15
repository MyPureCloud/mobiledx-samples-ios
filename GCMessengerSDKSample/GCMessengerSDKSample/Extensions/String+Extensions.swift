// ===================================================================================================
// Copyright © 2023 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation

enum ConvertError: Error {
    case invalidJson
    case invalidData
    case unableToSerializeJson
    case emptyData
}

extension String {
    func convertStringToDictionary() throws -> [String: String] {
        guard let data = self.data(using: .utf8) else { throw ConvertError.invalidData }
        guard !data.isEmpty else { throw ConvertError.emptyData }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String] {
                return json
            } else {
                throw ConvertError.invalidJson
            }
        } catch {
            throw ConvertError.unableToSerializeJson
        }
    }
}
