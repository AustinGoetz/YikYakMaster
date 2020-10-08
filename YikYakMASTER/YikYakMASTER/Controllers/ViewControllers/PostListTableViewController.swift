//
//  PostListTableViewController.swift
//  YikYakMASTER
//
//  Created by Austin Goetz on 10/6/20.
//

import UIKit

class PostListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostsAndReload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func composePostButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        // Possibly dispatch to main thread here instead of in the helper for time in the viewDidLoad
        fetchPostsAndReload()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

        let postToDisplay = PostController.shared.posts[indexPath.row]
        cell.updateViews(with: postToDisplay)

        return cell
    }
    
    // MARK: - Class Methods/Functions
    func presentAlertController() {
        let alertController = UIAlertController(title: "Get Yikkity Yakkity!", message: "Content is user generated and shared with everyone keep that in mind!", preferredStyle: .alert)
        
        alertController.addTextField { (bodyTextField) in
            bodyTextField.placeholder = "Put your message here! 🐃"
        }
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name: Preferably not your own! 🤫"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let bodyText = alertController.textFields?[0].text,
                  let author = alertController.textFields?[1].text,
                  !bodyText.isEmpty, !author.isEmpty else { return }
            
            PostController.shared.savePost(with: bodyText, author: author) { (result) in
                switch result {
                case .success(let post):
                    PostController.shared.posts.append(post)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchPostsAndReload() {
        PostController.shared.fetchAllPosts { (result) in
            switch result {
            case .success(let posts):
                PostController.shared.posts = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        // I: Identifier
        if segue.identifier == "toDetailVC" {
            // I: Index
            if let indexPath = tableView.indexPathForSelectedRow {
                // D: Destination
                guard let destinationVC = segue.destination as? PostDetailViewController else { return }
                // O: Object to send
                let postToSend = PostController.shared.posts[indexPath.row]
                // O: receive Object
                destinationVC.post = postToSend
            }
        }
    }
}
