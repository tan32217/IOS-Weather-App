//
//  WeatherResponse.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation


struct WeatherResponse: Codable {
    let city: String
    let state: String
    let latitude: Double
    let longitude: Double
    let weather: WeatherData
}

struct WeatherData: Codable {
    let data: WeatherTimelines
}

struct WeatherTimelines: Codable {
    let timelines: [WeatherTimeline]
    let warnings: [WeatherWarning]?
}

struct WeatherWarning: Codable {
    let code: Int
    let type: String
    let message: String
    let meta: WeatherWarningMeta
}

struct WeatherWarningMeta: Codable {
    let field: String
    let from: String
    let to: String
}

struct WeatherTimeline: Codable {
    let timestep: String
    let startTime: String?
    let endTime: String?
    let intervals: [WeatherInterval]
}

struct WeatherInterval: Codable {
    let startTime: String
    let values: WeatherValues
}

struct WeatherValues: Codable {
    let cloudCover: Double
    let humidity: Double
    let moonPhase: Int
    let precipitationProbability: Int
    let precipitationType: Int?
    let pressureSeaLevel: Double
    let sunriseTime: String
    let sunsetTime: String
    let temperature: Double
    let temperatureApparent: Double
    let temperatureMax: Double
    let temperatureMin: Double
    let uvIndex: Int?
    let visibility: Double
    let weatherCode: Int
    let windDirection: Double
    let windSpeed: Double
}
