//
//  PostDetailViewController.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties
    /// Landing Pad
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let text = postTextView.text, !text.isEmpty, let author = nameTextField.text, !author.isEmpty else { return }
        if let post = post {
            post.text = text
            post.author = author
            PostController.shared.update(post) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Class Functions
    func updateViews() {
        guard let post = post else { return }
        postTextView.text = post.text
        nameTextField.text = post.author
    }
}
