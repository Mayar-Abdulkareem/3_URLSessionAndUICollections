//
//  ApiHandler.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 10/10/2023.
//

import Foundation
import UIKit

class ApiHandler {
    
    static let sharedInstance = ApiHandler()
    
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
    
    func getUser(userName: String) async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/\(userName)"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw determineError((response as? HTTPURLResponse)?.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
        
    func getFollowers(url: String) async throws -> [GitHubFollower] {
        guard let followerURL = URL(string: url) else {
            throw GHError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: followerURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw determineError((response as? HTTPURLResponse)?.statusCode)
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

    
}
