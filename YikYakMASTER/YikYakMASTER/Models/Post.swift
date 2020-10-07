//
//  Post.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import Foundation
import CloudKit

// MARK: - String Constants
struct PostStrings {
    static let recordTypeKey = "Post"
    fileprivate static let textKey = "text"
    fileprivate static let authorKey = "author"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let scoreKey = "score"
}

class Post {
    let text: String
    let author: String
    let timestamp: Date
    var score: Int
    
    let ckRecordID: CKRecord.ID
    
    init(text: String, author: String, timestamp: Date = Date(), score: Int = 0, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.score = score
        
        self.ckRecordID = ckRecordID
    }
}

extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let text = ckRecord[PostStrings.textKey] as? String,
              let author = ckRecord[PostStrings.authorKey] as? String,
              let timestamp = ckRecord[PostStrings.timestampKey] as? Date,
              let score = ckRecord[PostStrings.scoreKey] as? Int else { return nil }
        
        self.init(text: text, author: author, timestamp: timestamp, score: score, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordTypeKey, recordID: post.ckRecordID)
        
        self.setValuesForKeys([
            PostStrings.textKey : post.text,
            PostStrings.authorKey : post.author,
            PostStrings.timestampKey : post.timestamp,
            PostStrings.scoreKey : post.score
        ])
    }
}
