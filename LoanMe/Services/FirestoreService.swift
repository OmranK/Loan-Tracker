//
//  FirestoreService.swift
//  LoanMe
//
//  Created by Omran Khoja on 1/3/20.
//

import Foundation
import Firebase

class FirestoreService {
    
    private init () {}
    static let shared = FirestoreService()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: FirestoreCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func createEntry<T: Encodable>(for encodableObject: T, in collectionReference: FirestoreCollectionReference) {
        do {
            let json = try encodableObject.toJSON(exluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
        } catch {
            print(error)
        }
    }
    
    func read<T: Decodable>(from collectionReference: FirestoreCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                var objectsArray = [T]()
                for document in snapshot.documents {
                    let object = try document.decoded(as: objectType.self)
                    objectsArray.append(object)
                }
                
                completion(objectsArray)
                
            } catch {
                print(error)
            }
        }
    }
    
    func update<T: Encodable & FirebaseObject>(for encodableObject: T, in collectionReference: FirestoreCollectionReference) {
        do {
            let json = try encodableObject.toJSON(exluding: ["id"])
            guard let id = encodableObject.id else { throw NetworkError.idError}
            reference(to: collectionReference).document(id).setData(json)
        } catch  {
            print(error)
        }
    }
    
    func delete<T: FirebaseObject>(_ identifiableObject: T, in collectionReference: FirestoreCollectionReference) {
        
        do {
            guard let id = identifiableObject.id else { throw NetworkError.idError}
            reference(to: collectionReference).document(id).delete()
        } catch  {
            print(error)
        }
    }
}

