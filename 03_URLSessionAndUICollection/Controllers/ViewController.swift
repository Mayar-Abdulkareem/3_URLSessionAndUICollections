//
//  ViewController.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        Task {
            var errorMsg = ""
            configureActivityIndicator()
            showActivityIndicator()
            do {
                let user = try await ApiHandler.sharedInstance.getUser(userName: userName.text ?? "SAllen0400")
                let destVC = storyboard?.instantiateViewController(withIdentifier: UserVC.id) as? UserVC
                destVC?.user = user
                if let navigationController = self.navigationController, let userVC = destVC {
                    navigationController.pushViewController(userVC, animated: true)
                } else {
                    self.showAlert(alertModel: AlertModel(title: "Failure", msg: "Failed to push the UserVC."))
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
            hideActivityIndicator()
        }
    }
}





