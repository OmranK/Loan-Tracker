//
//  EncodableExtension.swift
//  LoanMe
//
//  Created by Omran Khoja on 1/3/20.
//

import Foundation

enum NetworkError: Error {
    case encodingError
    case idError
}


extension Encodable {
    
    func toJSON(exluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw NetworkError.encodingError}
        
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
    
}
