//
//  Post.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import Foundation
import CloudKit

// MARK: - String Constants
/**
 PostStrings contains the String values for keys when setting values for CKRecords
 */
struct PostStrings {
    static let recordTypeKey = "Post"
    fileprivate static let textKey = "text"
    fileprivate static let authorKey = "author"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let scoreKey = "score"
}

// MARK: - Class Declaration
class Post {
    /// String value of the Post message text
    var text: String
    /// String value of the Post author name
    var author: String
    /// Date value of when the Post was created
    let timestamp: Date
    /// Int value of the Post score
    var score: Int
    /// The ID of the Post object's CKRecord
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

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.timestamp == rhs.timestamp
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
