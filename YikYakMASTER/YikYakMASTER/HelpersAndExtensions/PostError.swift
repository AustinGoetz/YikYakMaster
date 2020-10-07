//
//  PostError.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import Foundation

enum PostError: LocalizedError {
    case thrownError(Error)
    case unableToUnwrap
    
    var errorDescription: String? {
        switch self {
        case .thrownError(let error):
            return "Error in \(#function) : \(error.localizedDescription) \n---\n \(error)"
        case .unableToUnwrap:
            return "Unable to unwrap result returned from \(#function)"
        }
    }
}
