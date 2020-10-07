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
    func createPost(with text: String, author: String, completion: @escaping (Result<Post, PostError>) -> Void) {
        let newPost = Post(text: text, author: author)
        let newRecord = CKRecord(post: newPost)
        publicDB.save(newRecord) { (record, error) in
            if let error = error {
                return completion(.failure(<#T##PostError#>))
            }
        }
    }
}
