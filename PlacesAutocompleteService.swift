//
//  PlacesAutocompleteService.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//


import Foundation

class PlacesAutocompleteService {
    private let apiKey = "AIzaSyBnoi1yNNHaEeJza6kj2P2eS8aG-Dckwcw"
    private let baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

    func fetchAutocompleteSuggestions(for query: String, completion: @escaping ([String]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?input=\(encodedQuery)&types=(cities)&components=country:us&key=\(apiKey)") else {
            completion([])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }

            do {
                let result = try JSONDecoder().decode(PlacesAutocompleteResponse.self, from: data)
                let suggestions = result.predictions.map { $0.description }
                completion(suggestions)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
}

// Define Models for JSON Decoding
struct PlacesAutocompleteResponse: Codable {
    let predictions: [Prediction]
}

struct Prediction: Codable {
    let description: String
}
