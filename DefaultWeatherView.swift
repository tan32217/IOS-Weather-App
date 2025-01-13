////
////  DefaultWeatherView.swift
////  WeatherInfo
////
////  Created by d22guest on 12/12/24.
////
//
//import Foundation
//import SwiftUI
//
//struct DefaultWeatherView: View {
//    @ObservedObject var weatherVM: WeatherViewModel
//
//    var body: some View {
//        VStack {
//            let weatherInfo = weatherVM.getWeatherDescriptionAndIcon(for: weatherVM.statusCode)
//            WeatherBlockView(
//                temperature: "\(String(format: "%.0f", weatherVM.temperature2))°F",
//                condition: weatherInfo.description,
//                location: weatherVM.cityName,
//                weatherIcon: weatherInfo.icon
//            )
//            .padding()
//
//            WeatherDetailsView(details: [
//                ("Humidity", "Humidity", "\(String(format: "%.0f", weatherVM.humidity))%"),
//                ("Wind Speed", "Wind", "\(String(format: "%.2f", weatherVM.windSpeed)) mph"),
//                ("Visibility", "Visibility", "\(String(format: "%.2f", weatherVM.visibility)) mi"),
//                ("Pressure", "Pressure", "\(String(format: "%.2f", weatherVM.pressure)) inHg")
//            ])
//            .padding()
//
//            WeatherTableView(weatherData: weatherVM.weatherTableData)
//        }
//        .onAppear {
//            print("DefaultWeatherView appeared")
//        }
//    }
//}
