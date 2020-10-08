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
    // Create
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
    
    // Read
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
    
    // Update
    func update(_ post: Post, completion: @escaping (Result<Post, PostError>) -> Void) {
        
        let recordToUpdate = CKRecord(post: post)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let record = records?.first,
                  let updatedPost = Post(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
            print("Updated \(record.recordID.recordName) successfully in CloudKit")
            completion(.success(updatedPost))
        }
        publicDB.add(operation)
    }
}
