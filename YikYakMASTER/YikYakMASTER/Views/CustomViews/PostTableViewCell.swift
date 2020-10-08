//
//  PostTableViewCell.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var pointTotalLabel: UILabel!
    
    // MARK: - Properties
    var post: Post?
    
    // MARK: - Actions
    @IBAction func upvoteButtonTapped(_ sender: UIButton) {
        if let post = post {
            post.score += 1
            pointTotalLabel.text = "\(post.score)"
            PostController.shared.update(post) { (_) in
            }
        }
    }
    
    @IBAction func downvoteButtonTapped(_ sender: UIButton) {
        if let post = post {
            post.score -= 1
            pointTotalLabel.text = "\(post.score)"
            PostController.shared.update(post) { (_) in
            }
        }
    }
    
    // MARK: - Class Methods/Functions
    func updateViews(with post: Post) {
        self.post = post
        postTextLabel.text = "\"\(post.text)\"\n- \(post.author)"
        pointTotalLabel.text = "\(post.score)"
    }
}
