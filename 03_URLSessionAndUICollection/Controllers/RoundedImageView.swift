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

            // Calculate the corner radius as half of the image view's width
            let cornerRadius = min(bounds.width, bounds.height) / 2.0

            // Apply the corner radius to make the image view round
            layer.cornerRadius = cornerRadius

            // Ensure that content outside the rounded corners is clipped
            clipsToBounds = true
        }
    
    static func loadImageFromURLAsync(_ urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data), let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
            throw ImageError.invalidImageData
        }
        
        return image
    }


}
