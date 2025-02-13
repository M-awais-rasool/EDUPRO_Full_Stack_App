//
//  AuthModel.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import Foundation

struct LoginResponse: Decodable {
    let data: LoginData
    let message: String
    let status: String
}

struct LoginData: Decodable {
    let email: String
    let image: String
    let name: String
    let token: String
    let userId: String
}

struct ErrorResponse: Decodable {
    let message: String
    let status: String
}




enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case invalidToken
    case serverError(message: String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .decodingError:
            return "Failed to decode the data."
        case .serverError(let message):
            return message
        case .invalidToken:
            return "token messing"
        case .unknown(let message):
            return message
        }
    }
}
