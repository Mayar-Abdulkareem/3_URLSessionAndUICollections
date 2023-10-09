//
//  ViewController.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    private func getUser() async throws -> GitHubUser {
        let userName = self.userName.text ?? "SAllen0400"
        let endpoint = "https://api.github.com/users/\(userName)"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                throw determineError((response as? HTTPURLResponse)?.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    private func determineError(_ statusCode: Int?) -> GHError {
        if let statusCode = statusCode {
            switch statusCode {
            case 404: return GHError.resourceNotFound
            case 422: return GHError.validationFailed
            default: return GHError.invalidResponse
            }
        } else {
            return GHError.invalidResponse
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        Task {
            var errorMsg = ""
            do {
                let user = try await getUser()
                let destVC = storyboard?.instantiateViewController(withIdentifier: UserVC.id) as! UserVC
                destVC.user = user
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
                MyAlert.showAlert(alertModel: AlertModel(title: "Failure", msg: errorMsg, viewController: self))
            }
        }
    }
    
}



