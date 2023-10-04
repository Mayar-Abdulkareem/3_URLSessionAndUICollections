//
//  userVC.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class userVC: UIViewController {
    
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
        myAlert.showAlert(alertModel: AlertModel(title: "Success", msg: "User Fetched successfully", viewController: self))
        fetchImage()
        configureUI()
    }
    
    
    private func fetchImage() {
        Task{
            do {
                avatarImage.image = try await RoundedImageView.loadImageFromURLAsync(user.avatarUrl)
            } catch {
                myAlert.showAlert(alertModel: AlertModel(title: "Failure", msg: "Invalid Data", viewController: self))
            }
        }
    }
    
    private func configureUI() {
        loginName.text = user.name
        bioLabel.text = user.bio
        countLabel.text = "\(user.name) has \(user.followers) followers"
    }
    
    private func getFollowers() async throws -> [GitHubFollower] {
        guard let followerURL = URL(string: user.followersUrl) else {
            throw GHError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: followerURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                switch (response as? HTTPURLResponse)?.statusCode {
                case 404: throw GHError.resourceNotFound
                case 422: throw GHError.validationFailed
                default: throw GHError.invalidResponse
                }
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                return try decoder.decode([GitHubFollower].self, from: data)
            } catch {
                let dataString = String(data: data, encoding: .utf8)
                print("Error decoding data: \(error)")
                print("JSON Data: \(dataString ?? "N/A")")
                throw error
            }
        } catch {
            throw GHError.invalidData
        }
    }
    
    private func fetchFollowers() {
        Task {
            var errorMsg = ""
            do {
                self.followers = try await getFollowers()
                let destVC = storyboard?.instantiateViewController(withIdentifier: followerVC.id) as! followerVC
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
                myAlert.showAlert(alertModel: AlertModel(title: "Failure", msg: errorMsg, viewController: self))
            }
        }
    }
    
    @IBAction func getFollowersBtnTapped(_ sender: Any) {
        fetchFollowers()
    }
    
}
