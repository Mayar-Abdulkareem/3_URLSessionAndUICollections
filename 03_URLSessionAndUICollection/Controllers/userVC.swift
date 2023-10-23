//
//  userVC.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class UserVC: UIViewController {
    
    @IBOutlet weak var avatarImage: RoundedImageView!
    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    static let id = "userVCID"
    var user: GitHubUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        configureUILabel()
    }
    
    private func fetchImage() {
        Task{
            do {
                avatarImage.image = try await ImageUtility.shared.loadImageFromURLAsync(user.avatarUrl)
            } catch {
                print("Error loading the image")
            }
        }
    }
    
    private func configureUILabel() {
        loginName.text = user.name
        bioLabel.text = user.bio
        
        let attributedText = NSMutableAttributedString(string: "\(user.name) has \(user.followers) followers")
        let range = (attributedText.string as NSString).range(of: String(user.followers))
        attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 16)], range: range)
        countLabel.attributedText = attributedText
    }
    
    @IBAction func getFollowersBtnTapped(_ sender: Any) {
        Task {
            var errorMsg = ""
            do {
                let followers = try await ApiHandler.sharedInstance.getFollowers(url: user.followersUrl)
                let destVC = storyboard?.instantiateViewController(withIdentifier: FollowerVC.id) as? FollowerVC
                destVC?.followers = followers
                if let navigationController = self.navigationController, let followerVC = destVC {
                    navigationController.pushViewController(followerVC, animated: true)
                } else {
                    self.showAlert(alertModel: AlertModel(title: "Failure", msg: "Failed to push the followerVC."))
                }
            } catch Errors.invalidURL {
                errorMsg = "invalid URL"
            } catch Errors.resourceNotFound {
                errorMsg = "Resource not found"
            } catch Errors.validationFailed {
                errorMsg = "Validation Faild"
            } catch Errors.invalidResponse {
                errorMsg = "invalid response"
            } catch Errors.invalidData {
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
