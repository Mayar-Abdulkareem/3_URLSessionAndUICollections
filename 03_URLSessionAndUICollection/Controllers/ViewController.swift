//
//  ViewController.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped =  true
        view.addSubview(activityIndicator)
    }
    
    private func activateActivityIndicator(isActive: Bool) {
        if isActive {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        Task {
            var errorMsg = ""
            do {
                configureActivityIndicator()
                activateActivityIndicator(isActive: true)
                let user = try await ApiHandler.sharedInstance.getUser(userName: userName.text ?? "SAllen0400")
                activateActivityIndicator(isActive: false)
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
                self.showAlert(alertModel: AlertModel(title: "Failure", msg: errorMsg))
            }
        }
    }
    
}





