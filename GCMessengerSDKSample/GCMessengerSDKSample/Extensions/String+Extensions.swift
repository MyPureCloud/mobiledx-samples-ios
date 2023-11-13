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
    func convertStringToDictionary() -> Result<[String:String], ConvertError> {
        if let data = self.data(using: .utf8) {
            
            guard data.isEmpty == false else {
                return .failure(.emptyData)
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:String] {
                    return .success(json)
                } else {
                    return .failure(.invalidJson)
                }
            } catch {
                return .failure(.unableToSerializeJson)
            }
        }
        return .failure(.invalidData)
    }
}
