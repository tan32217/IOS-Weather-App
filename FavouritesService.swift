//
//  FavouritesService.swift
//  WeatherInfo
//
//  Created by d22guest on 12/12/24.
//

import Foundation


struct FavoriteCity: Codable {
    let id: String
    let city: String
    let state: String
}

class FavoritesService {
    private let baseURL = "http://127.0.0.1:3002/api/favorites"
    
    // Fetch all favorite cities
    func fetchFavorites(completion: @escaping (Result<[FavoriteCity], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(FavoritesServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(FavoritesServiceError.noData))
                return
            }
            
            do {
                let favorites = try JSONDecoder().decode([FavoriteCity].self, from: data)
                completion(.success(favorites))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Save a favorite city
    func saveFavorite(city: String, state: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(FavoritesServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["city": city, "state": state]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(FavoritesServiceError.failedRequest))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    // Remove a favorite city
    func deleteFavorite(city: String, state: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?city=\(city)&state=\(state)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            completion(.failure(FavoritesServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(FavoritesServiceError.failedRequest))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
}

enum FavoritesServiceError: Error {
    case invalidURL
    case noData
    case failedRequest
}
