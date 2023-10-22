//
//  userVC.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class UserVC: UIViewController {
    
    static let id = "userVCID"
    var user: GitHubUser!
    var followersCount: Int = 0
    var followers: [GitHubFollower] = []
    
    @IBOutlet weak var avatarImage: RoundedImageView!
    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        configureUI()
    }
    
    private func fetchImage() {
        Task{
            do {
                avatarImage.image = try await ApiHandler.sharedInstance.loadImageFromURLAsync(user.avatarUrl)
            } catch {
                print("Error loading the image")
            }
        }
    }
    
    private func configureUI() {
        loginName.text = user.name
        bioLabel.text = user.bio
        countLabel.text = "\(user.name) has \(user.followers) followers"
    }
    
    @IBAction func getFollowersBtnTapped(_ sender: Any) {
        Task {
            var errorMsg = ""
            do {
                self.followers = try await ApiHandler.sharedInstance.getFollowers(url: user.followersUrl)
                let destVC = storyboard?.instantiateViewController(withIdentifier: FollowerVC.id) as! FollowerVC
                destVC.followers = self.followers
                navigationController?.pushViewController(destVC, animated: true)
            } catch GHError.invalidURL {
                errorMsg = "invalid URL"
            } catch GHError.resourceNotFound {
                errorMsg = "Resource not found"
            } catch GHError.validationFailed {
                errorMsg = "Validation Faild"
            } catch GHError.invalidResponse {
                errorMsg = "invalid response"
            } catch GHError.invalidData {
                errorMsg = "invalid data"
            } catch {
                print("unexpected error")
            }
            if (!errorMsg.isEmpty) {
                self.showAlert(alertModel: AlertModel(title: "Failure", msg: errorMsg))
            }
        }
    }
    
}
