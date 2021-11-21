//
//  APIResponse.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import Foundation

//MARK: APIResult
enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

//MARK: APIResponse
struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

//MARK: APIResponse Extension
extension APIResponse where Body == Data? {
    func decode<T: Decodable>(to type: T.Type) throws -> APIResponse<T> {
        guard let data = body else {
            throw APIError.dataFailed
        }
     
        guard let decodedJSON = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.decodingFailed
        }
        
        return APIResponse<T>(statusCode: self.statusCode, body: decodedJSON)
    }
}


// MARK: APIError
enum APIError: LocalizedError {
    case invalidURL
    case requestFailed
    case networkFailed
    case decodingFailed
    case dataFailed
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed:
            return "Please Try Again, Request failed"
        case .networkFailed:
            return "Unable to reach network"
        case .decodingFailed:
            return "Failed to parse API response"
        case .dataFailed:
            return "Failed to find data in response"
        }
    }
}

