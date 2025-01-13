//
//  TodayView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation

import Foundation
import SwiftUI

struct TodayView: View {
    // Sample data for the weather cards
    var windSpeed: Double
    var pressure: Double
    var precipitation: Int
        
        
    var temperature2: Double
    var statusCode: Int
    var humidity: Double
    var condition: String
        
    var visibility: Double
    var cloudCover: Double
    var uvIndex: Int
    
    
    
    var body: some View {
        let weatherData = [
            ("Wind Speed", "\(String(format: "%.0f", windSpeed)) mph", "WindSpeed"),
                       ("Pressure", "\(String(format: "%.0f", pressure)) inHG", "Pressure"),
                       ("Precipitation", "\(precipitation) %", "Precipitation"),
                       ("Temperature", "\(String(format: "%.0f", temperature2)) °F", "Temperature"),
                       ("Condition", condition, "Cloudy"),
                       ("Humidity", "\(String(format: "%.0f", humidity)) %", "Humidity"),
                       ("Visibility", "\(String(format: "%.0f", visibility)) mi", "Visibility"),
                       ("Cloud Cover", "\(cloudCover) %", "CloudCover"),
                       ("UV Index", "\(uvIndex)", "UVIndex")
        ]
       
            
            // VStack containing rows (HStacks) of weather cards
            ScrollView {
                ZStack {
                    // Background Image
                    Image("App_background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ForEach(0..<weatherData.count / 3, id: \.self) { row in
                        HStack(spacing: 20) {
                            ForEach(0..<3, id: \.self) { column in
                                let index = row * 3 + column
                                if index < weatherData.count {
                                    WeatherCard(
                                        title: weatherData[index].0,
                                        value: weatherData[index].1,
                                        iconName: weatherData[index].2
                                    )
                                }
                            }
                        }
                    }
                }
//                .padding(50)
            }
            .padding(.top, -60)
        }
    }
}

struct WeatherCard: View {
    let title: String
    let value: String
    let iconName: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50) // Icon size
//                .foregroundColor(.black)
            
            Text(value)
                .foregroundColor(.black)
                .font(.system(size: 14))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .frame(width: 80, height: 140) // Card size
        .padding()
        .background(Color.white.opacity(0.4))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
        
    }
}
