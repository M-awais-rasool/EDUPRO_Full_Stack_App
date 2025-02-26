//
//  DELETE.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 26/02/2025.
//

import Foundation

func DeleteKeyWord(id: String)async throws -> ErrorResponse{
    do{
        guard let url = URL(string:"http://localhost:8080/Search/delete-keyword/\(id)") else{
            throw APIError.invalidURL
        }
        guard let token = getToken() else {
            throw APIError.invalidToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
            throw APIError.serverError(message: errorResponse.message)
        }
        return try decoder.decode(ErrorResponse.self, from: data)
    }catch{
        print("Caught APIError: \(error)")
        throw error
    }
}

func removeBookMark(id: String)async throws -> ErrorResponse{
    do{
        guard let url = URL(string:"http://localhost:8080/bookmarks/remove-bookMark/\(id)") else{
            throw APIError.invalidURL
        }
        guard let token = getToken() else {
            throw APIError.invalidToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        let decoder = JSONDecoder()
        if httpResponse.statusCode != 200 {
            let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
            throw APIError.serverError(message: errorResponse.message)
        }
        
        return try decoder.decode(ErrorResponse.self, from: data)
    }
    catch{
        throw error
    }
}
