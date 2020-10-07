//
//  PostDetailViewController.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var postTextLabel: UILabel!
    
    // MARK: - Properties
    /// Landing Pad
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            guard let post = post else { return }
            postTextLabel.text = "\"\(post.text)\"\n - \(post.author)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
