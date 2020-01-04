//
//  SnapshotExtension.swift
//  
//
//  Created by Omran Khoja on 1/3/20.
//

import Foundation
import Firebase

extension DocumentSnapshot {
    
    func decoded<T: Decodable>(as objectType: T.Type, includingID: Bool = true) throws -> T {
        
        var documentJSON = data()
        if includingID {
            documentJSON?["id"] = documentID
        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJSON, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
}
