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
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func fetchData<T: Decodable>(_ url: String) async throws -> T {
        guard let endpoint = URL(string: url) else {
            throw Errors.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw determineError((response as? HTTPURLResponse)?.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw Errors.invalidData
        }
    }
        
    func getUser(userName: String) async throws -> GitHubUser {
        do {
            return try await fetchData(Constants.UrlBasePoint.gitHubUsersUrl + userName)
        } catch {
            throw error
        }
    }
        
    func getFollowers(url: String) async throws -> [GitHubFollower] {
        do {
            return try await fetchData(url)
        } catch {
            throw error
        }
    }
    
    private func determineError(_ statusCode: Int?) -> Errors {
        if let statusCode = statusCode {
            switch statusCode {
            case 404: return Errors.resourceNotFound
            case 422: return Errors.validationFailed
            default: return Errors.invalidResponse
            }
        } else {
            return Errors.invalidResponse
        }
    }
}
