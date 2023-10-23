//
//  ImageUtility.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 23/10/2023.
//

import Foundation

import Foundation
import UIKit

class ImageUtility {
    static let shared = ImageUtility()
    
    func loadImageFromURLAsync(_ urlString: String) async throws -> UIImage {
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
