//
//  RoundedImageView.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 02/10/2023.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = min(bounds.width, bounds.height) / 2.0
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
//    func loadImageFromURLAsync(_ urlString: String) async throws {
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        guard let myImage = UIImage(data: data), let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
//            throw ImageError.invalidImageData
//        }
//
//        self.image = myImage
//    }
    
}
