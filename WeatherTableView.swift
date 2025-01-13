//
//  WeatherTableView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation

import SwiftUI

struct WeatherTableView: View {
    let weatherData: [(date: String, icon: String, sunrise: String, sunset: String)] // Accept dynamic data

    var body: some View {
        ScrollView {
            VStack {
                ForEach(weatherData, id: \.date) { data in
                    HStack(spacing: 16) {
                        // Date
                        Text(data.date)
                            .font(.system(size: 15))
                            .frame(alignment: .leading)
                        
                        // Weather Icon
                        Image( data.icon)
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        // Sunrise Icon and Time
                        HStack {
                            Text(data.sunrise)
                                .font(.system(size: 10))
                            Image(systemName: "sunrise.fill")
                                .foregroundColor(.orange)
                        }
                        
                        // Sunset Icon and Time
                        HStack {
                            Text(data.sunset)
                                .font(.system(size: 10))
                            Image(systemName: "sunset.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 19)
                }
            }
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .frame(height: 300)
    }
}

struct WeatherTableView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTableView(weatherData: [
            ("11/15/2024", "Clear", "6:00 AM", "5:00 PM"),
            ("11/16/2024", "Clear", "6:01 AM", "5:01 PM"),
        ])
    }
}
