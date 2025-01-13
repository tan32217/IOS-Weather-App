//
//  WeatherService.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation

class WeatherService: ObservableObject {
    @Published var weatherResponse: WeatherResponse? // Single WeatherResponse object, not an array

    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "http://localhost:3002/get-weather?lat=\(latitude)&lon=\(longitude)" // Replace localhost with IP if needed
        print("Fetching weather data from: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }

            do {
                // Decode the JSON into the WeatherResponse model
                let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)

                DispatchQueue.main.async {
                    self?.weatherResponse = decodedResponse
                    completion(decodedResponse)
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError)")
                print("Raw JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                completion(nil)
            }
        }.resume()
    }
}
