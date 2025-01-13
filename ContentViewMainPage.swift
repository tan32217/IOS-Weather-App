////
////  ContentViewMainPage.swift
////  WeatherInfo
////
////  Created by d22guest on 12/11/24.
////
//
//import Foundation
//import SwiftUI
//class WeatherViewModel: ObservableObject {
//    @Published var cityName: String = ""
//    @Published var windSpeed: Double = 0.0
//    @Published var pressure: Double = 0.0
//    @Published var precipitation: Int = 0
//    @Published var temperature2: Double = 0.0
//    @Published var statusCode: Int = 0
//    @Published var humidity: Double = 0.0
//    @Published var condition: String = ""
//    @Published var visibility: Double = 0.0
//    @Published var cloudCover: Double = 0.0
//    @Published var uvIndex: Int = 0
//    @Published var weatherTableData: [(date: String, icon: String, sunrise: String, sunset: String)] = []
//    @Published var weeklyData: [(day: Int, minTemp: Double, maxTemp: Double)] = []
//
//
//
//    private let weatherService = WeatherService()
//
//    func fetchWeatherData(latitude: Double, longitude: Double) {
//        weatherService.fetchWeatherData(latitude: latitude, longitude: longitude) { response in
//            if let response = response {
//                DispatchQueue.main.async {
//                    self.cityName = response.city
//                    self.statusCode = response.weather.data.timelines[0].intervals[0].values.weatherCode
//                    self.temperature2 = response.weather.data.timelines[0].intervals[0].values.temperature
//                    self.humidity = response.weather.data.timelines[0].intervals[0].values.humidity
//                    self.windSpeed = response.weather.data.timelines[0].intervals[0].values.windSpeed
//                    self.visibility = response.weather.data.timelines[0].intervals[0].values.visibility
//                    self.pressure = response.weather.data.timelines[0].intervals[0].values.pressureSeaLevel
//                    self.precipitation = response.weather.data.timelines[0].intervals[0].values.precipitationType ?? 0
//                    self.cloudCover = response.weather.data.timelines[0].intervals[0].values.cloudCover
//                    self.uvIndex = response.weather.data.timelines[0].intervals[0].values.uvIndex ?? 0
//
//                    let intervals = response.weather.data.timelines[0].intervals
//
//                    self.weatherTableData = self.mapIntervalsToWeatherData(intervals:intervals)
//
//                    self.weeklyData = intervals.enumerated().map { (index, interval) in
//                                            let minTemp = interval.values.temperatureMin
//                                            let maxTemp = interval.values.temperatureMax
//                                            return (day: index + 1, minTemp: minTemp, maxTemp: maxTemp)
//                                        }
//
//
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.cityName = "Error fetching city"
//                    self.statusCode = 0
//                    self.temperature2 = 0.0
//                }
//            }
//        }
//    }
//
//    func mapIntervalsToWeatherData(intervals: [WeatherInterval]) -> [(date: String, icon: String, sunrise: String, sunset: String)] {
//        return intervals.map { interval in
//            let date = formatDate(interval.startTime)
//            let weatherIcon = getWeatherDescriptionAndIcon(for: interval.values.weatherCode).description
//            let sunrise = formatTime(interval.values.sunriseTime)
//            let sunset = formatTime(interval.values.sunsetTime)
//            return (date: date, icon: weatherIcon, sunrise: sunrise, sunset: sunset)
//        }
//    }
//
//    func getWeatherDescriptionAndIcon(for statusCode: Int) -> (description: String, icon: String) {
//            let weatherCodes: [Int: (description: String, icon: String)] = [
//                4201: ("Heavy Rain", "rain_heavy.svg"),
//                4001: ("Rain", "rain.svg"),
//                4200: ("Light Rain", "rain_light.svg"),
//                6201: ("Heavy Freezing Rain", "freezing_rain_heavy.svg"),
//                6001: ("Freezing Rain", "freezing_rain.svg"),
//                6200: ("Light Freezing Rain", "freezing_rain_light.svg"),
//                6000: ("Freezing Drizzle", "freezing_drizzle.svg"),
//                4000: ("Drizzle", "drizzle.svg"),
//                7101: ("Heavy Ice Pellets", "ice_pellets_heavy.svg"),
//                7000: ("Ice Pellets", "ice_pellets.svg"),
//                7102: ("Light Ice Pellets", "ice_pellets_light.svg"),
//                5101: ("Heavy Snow", "snow_heavy.svg"),
//                5000: ("Snow", "snow.svg"),
//                5100: ("Light Snow", "snow_light.svg"),
//                5001: ("Flurries", "flurries.svg"),
//                8000: ("Thunderstorm", "tstorm.svg"),
//                2100: ("Light Fog", "fog_light.svg"),
//                2000: ("Fog", "fog.svg"),
//                1001: ("Cloudy", "cloudy.svg"),
//                1102: ("Mostly Cloudy", "mostly_cloudy.svg"),
//                1101: ("Partly Cloudy", "partly_cloudy_day.svg"),
//                1100: ("Mostly Clear", "mostly_clear_day.svg"),
//                1000: ("Clear", "clear_day.svg")
//            ]
//        return weatherCodes[statusCode] ?? ("Unknown Weather", "unknown.svg")
//    }
//
//    func formatDate(_ dateString: String) -> String {
//        let inputFormatter = ISO8601DateFormatter()
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "yyyy/MM/dd"
//        if let date = inputFormatter.date(from: dateString) {
//            return outputFormatter.string(from: date)
//        }
//        return "N/A"
//    }
//
//    func formatTime(_ time: String) -> String {
//        let isoFormatter = ISO8601DateFormatter()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//        if let date = isoFormatter.date(from: time) {
//            return dateFormatter.string(from: date)
//        }
//        return "N/A"
//    }
//
//    func getWeatherData() -> [String: Any] {
//        return [
//            "temperature": temperature2,
//            "condition": condition,
//            "humidity": humidity,
//            "windSpeed": windSpeed,
//            "visibility": visibility,
//            "pressure": pressure
//        ]
//    }
//
//}
//struct City {
//    let name: String
//    let state: String
//}
//struct ContentViewMainPage: View {
//    @StateObject var weatherVM = WeatherViewModel()
//    @State private var searchText: String = ""
//    @State private var isNavigating: Bool = false
//    @State private var selectedCity: City?
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Background image
//                Image("App_background")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                    .offset(y: 79)
//                
//                VStack(spacing: 15) {
//                    
//                    // City Search View
//                    CitySearchView(searchText: $searchText, onCitySelected: { name, state in
//                        selectedCity = City(name: name, state: state)
//                        isNavigating = true
//                    })
//                    .zIndex(2)
//
//                    // NavigationLink for CityWeatherView
//                    NavigationLink(
//                        destination: selectedCity != nil ? AnyView(
//                            CityWeatherView(
//                                weatherVM: weatherVM,
//                                city: selectedCity?.name ?? "",
//                                state: selectedCity?.state ?? ""
//                            )
//                            .environmentObject(weatherVM)
//                        ) : AnyView(EmptyView()),
//                        isActive: $isNavigating
//                    ) {
//                        EmptyView()
//                    }
//                    .hidden()
//                    
//                    // Weather Information Section
//                    NavigationLink(
//                        destination: TabbedWeatherView(
//                            city: weatherVM.cityName,
//                            windSpeed: weatherVM.windSpeed,
//                            pressure: weatherVM.pressure,
//                            precipitation: weatherVM.precipitation,
//                            temperature2: weatherVM.temperature2,
//                            statusCode: weatherVM.statusCode,
//                            humidity: weatherVM.humidity,
//                            condition: weatherVM.getWeatherDescriptionAndIcon(for: weatherVM.statusCode).description,
//                            visibility: weatherVM.visibility,
//                            cloudCover: weatherVM.cloudCover,
//                            uvIndex: weatherVM.uvIndex,
//                            weeklyData: weatherVM.weeklyData
//                        )
//                        .environmentObject(weatherVM)
//                    ) {
//                        let weatherInfo = weatherVM.getWeatherDescriptionAndIcon(for: weatherVM.statusCode)
//                        WeatherBlockView(
//                            temperature: "\(String(format: "%.0f", weatherVM.temperature2))°F",
//                            condition: weatherInfo.description,
//                            location: weatherVM.cityName,
//                            weatherIcon: weatherInfo.description
//                        )
//                        .padding()
//                    }
//                    
//                    // Weather Details
//                    WeatherDetailsView(details: [
//                        ("Humidity", "Humidity", "\(String(format: "%.0f", weatherVM.humidity))%"),
//                        ("Wind Speed", "Wind Speed", "\(String(format: "%.2f", weatherVM.windSpeed)) mph"),
//                        ("Visibility", "Visibility", "\(String(format: "%.2f", weatherVM.visibility)) mi"),
//                        ("Pressure", "Pressure", "\(String(format: "%.2f", weatherVM.pressure)) inHg")
//                    ])
//                    .padding()
//                    
//                    // Weather Table View
//                    WeatherTableView(weatherData: weatherVM.weatherTableData)
//                }
//                .padding()
//                .onAppear {
//                    weatherVM.fetchWeatherData(latitude: 34.0549076, longitude: -118.242643)
//                }
//            }
//        }
//        .environmentObject(weatherVM)
//    }
//}
//
//struct ContentViewMainPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentViewMainPage()
//    }
//}
