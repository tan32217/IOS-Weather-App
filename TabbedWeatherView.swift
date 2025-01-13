//
//  TabbedWeatherView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation
import SwiftUI

struct TabbedWeatherView: View {
    var city:String
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
    var weeklyData: [(day: Int, minTemp: Double, maxTemp: Double)] // Add this parameter

    @State private var selectedTab: Int = 0
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Tab for TodayView
                TodayView(
                    windSpeed: windSpeed,
                    pressure: pressure,
                    precipitation: precipitation,
                    temperature2: temperature2,
                    statusCode: statusCode,
                    humidity: humidity,
                    condition: condition,
                    visibility: visibility,
                    cloudCover: cloudCover,
                    uvIndex: uvIndex
                )
                .tabItem {
                    Image("Today_Tab")
                        .foregroundColor(.blue)
                    Text("Today")
                }
                .tag(0)

                // Tab for WeeklyView
                WeeklyView(weeklyData: weeklyData,
                           condition:condition,
                           temperature2:temperature2)
                    .tabItem {
                        Image("Weekly_Tab")
                            .foregroundColor(.blue)
                        Text("Weekly")
                    }
                    .tag(1)

                // Tab for WeatherDataView
                WeatherDataView(
                   humidity: humidity,
                   cloudCover: cloudCover,
                   precipitation: precipitation
                )
                    .tabItem {
                        Image("Weather_Data_Tab")
                            .foregroundColor(.blue)
                        Text("Weather Data")
                    }
                    .tag(2)
            }
            .accentColor(.blue)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Weather")
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text((city))
                        .font(.headline)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Right button tapped")
                        shareToTwitter(message: "The current temperature at \(city) is \(String(format: "%.0f", temperature2))°F. The weather conditions are \(condition) #CSCI571WeatherSearch")
                    }) {
                        Image("twitter")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
           
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
    func shareToTwitter(message: String) {
            let tweetText = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let twitterUrl = URL(string: "twitter://post?message=\(tweetText)") // Opens Twitter app

            if let url = twitterUrl, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Fallback to Twitter website
                let webUrl = URL(string: "https://twitter.com/intent/tweet?text=\(tweetText)")!
                UIApplication.shared.open(webUrl)
            }
        }
}

struct Previews_TabbedWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
