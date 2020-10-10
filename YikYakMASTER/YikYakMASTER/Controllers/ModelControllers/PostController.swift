//
//  PostController.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import Foundation
import CloudKit

class PostController {
    
    // MARK: - Class Properties
    /// Shared Instance
    static let shared = PostController()
    /// Source of Truth
    var posts: [Post] = []
    /// Public Database reference
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    
    /// Saves a Post object to cloudkit container's public database
    /// - Parameters:
    ///   - text: String value for the Post object text
    ///   - author: String value for the Post object author name
    ///   - completion: Escaping completion block returning either a Post or a PostError as a Result
    func savePost(with text: String, author: String, completion: @escaping (Result<Post, PostError>) -> Void) {
        let newPost = Post(text: text, author: author)
        let newRecord = CKRecord(post: newPost)
        publicDB.save(newRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let record = record,
                  let savedPost = Post(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
            print("Saved YikYak successfully")
            completion(.success(savedPost))
        }
    }
    
    
    /// Fetches all post objects from cloudkit container's public database
    /// - Parameter completion: Escaping completion block returning either an array of Post objects or a PostError as a Result
    func fetchAllPosts(completion: @escaping (Result<[Post], PostError>) -> Void) {
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: fetchAllPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let records = records else { return completion(.failure(.unableToUnwrap)) }
            print("Fetched YikYaks successfully")
            let fetchedPosts = records.compactMap({ Post(ckRecord: $0) })
            completion(.success(fetchedPosts))
        }
    }
    
    
    /// Deletes a post object from cloudkit container
    /// - Parameters:
    ///   - post: The passed in Post to be deleted
    ///   - completion: Escaping completion block with a Result returning either a bool or a PostError
    func delete(post: Post, completion: @escaping (Result<Bool, PostError>) -> Void) {
        let recordToDelete = CKRecord(post: post)
        let recordIDofPostToDelete = recordToDelete.recordID
        let opertaion = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordIDofPostToDelete])
        
        opertaion.savePolicy = .allKeys
        opertaion.qualityOfService = .userInteractive
        opertaion.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let recordIDs = recordIDs else { return completion(.failure(.unableToUnwrap)) }
            print("Successfully deleted Post: \(recordIDs)")
            completion(.success(true))
        }
        publicDB.add(opertaion)
    }
    
    /// Updates a post object in the cloudkit container
    /// - Parameters:
    ///   - post: The passed in post to be updated
    ///   - completion: Escaping completion block returning either a Post or a PostError in form of a Result
    func update(_ post: Post, completion: @escaping (Result<Post, PostError>) -> Void) {
        // Step 3 - Define the record(s) to be updated
        let recordToUpdate = CKRecord(post: post)
        // Step 2 - Create the requisite operation
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        // Step 4 - Set the properties for the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            // Handle the error
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            // Ensure that the records were returned and updated
            guard let record = records?.first,
                  let updatedPost = Post(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
            print("Updated \(record.recordID.recordName) successfully in CloudKit")
            completion(.success(updatedPost))
        }
        // Step 1 - Add operation to the database
        publicDB.add(operation)
    }
}
