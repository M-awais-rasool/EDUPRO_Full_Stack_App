//
//  Post.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import Foundation

func loginApi(body:[String:Any])async throws -> LoginResponse{
    do{
        guard let url = URL(string:"http://localhost:8080/Auth/login") else{
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        let decoder = JSONDecoder()
        if httpResponse.statusCode != 200 {
            let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
            throw APIError.serverError(message: errorResponse.message)
        }
        
        return try decoder.decode(LoginResponse.self, from: data)
    }
    catch{
        throw error
    }
}
