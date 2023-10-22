//
//  ViewController.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
    }
    
    private func configureActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped =  true
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
            showActivityIndicator()
            do {
                let user = try await ApiHandler.sharedInstance.getUser(userName: userName.text ?? "SAllen0400")
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
            hideActivityIndicator()
        }
    }
    
}

struct AlertModel {
    let title: String
    let msg: String
}

extension UIViewController {
    func showAlert(alertModel: AlertModel) {
        let alertController = UIAlertController(title: alertModel.title, message: alertModel.msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}





