//
//  GET.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 25/02/2025.
//
import Foundation

func getToken() -> String? {
    return UserDefaults.standard.string(forKey: "token")
}

func GetHomeCourse()async throws -> HomeCourse{
    do{
        guard let url = URL(string:"http://localhost:8080/Course/get-courses") else{
            throw APIError.invalidURL
        }
        guard let token = getToken() else {
            throw APIError.invalidToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
        return try decoder.decode(HomeCourse.self, from: data)
    }catch{
        print("Caught APIError: \(error)")
        throw error
    }
}

func GetHomeMentors()async throws -> HomeMentor{
    do{
        guard let url = URL(string:"http://localhost:8080/mentor/get-mentors") else{
            throw APIError.invalidURL
        }
        guard let token = getToken() else {
            throw APIError.invalidToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
        return try decoder.decode(HomeMentor.self, from: data)
    }catch{
        print("Caught APIError: \(error)")
        throw error
    }
}

func GetCourseDetail(id:String)async throws -> CourseDetail{
    do{
        guard let url = URL(string:"http://localhost:8080/Course/get-course-details/\(id)") else{
            throw APIError.invalidURL
        }
        guard let token = getToken() else {
            throw APIError.invalidToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
        return try decoder.decode(CourseDetail.self, from: data)
    }catch{
        print("Caught APIError: \(error)")
        throw error
    }
}
