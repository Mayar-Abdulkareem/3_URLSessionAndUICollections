//
//  myAlert.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let msg: String
    let viewController: UIViewController
}

struct MyAlert {
    static func showAlert(alertModel: AlertModel) {
        let alertController = UIAlertController(title: alertModel.title, message: alertModel.msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        alertController.addAction(okAction)
        alertModel.viewController.present(alertController, animated: true, completion: nil)
    }
}


