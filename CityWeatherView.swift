
import Foundation
import SwiftUI
import SwiftSpinner


struct CityWeatherView: View {
    @StateObject private var weatherVM = WeatherViewModel()
    let city: String
    let state: String

    @State private var isLoading = true
    @State private var isFavorite: Bool = false
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    let onDisappear: () -> Void
    @Environment(\.presentationMode) var presentationMode

    func getWeatherDescriptionAndIcon(for statusCode: Int) -> (description: String, icon: String) {
        let weatherCodes: [Int: (description: String, icon: String)] = [
            4201: ("Heavy Rain", "rain_heavy.svg"),
            4001: ("Rain", "rain.svg"),
            4200: ("Light Rain", "rain_light.svg"),
            6201: ("Heavy Freezing Rain", "freezing_rain_heavy.svg"),
            6001: ("Freezing Rain", "freezing_rain.svg"),
            6200: ("Light Freezing Rain", "freezing_rain_light.svg"),
            6000: ("Freezing Drizzle", "freezing_drizzle.svg"),
            4000: ("Drizzle", "drizzle.svg"),
            7101: ("Heavy Ice Pellets", "ice_pellets_heavy.svg"),
            7000: ("Ice Pellets", "ice_pellets.svg"),
            7102: ("Light Ice Pellets", "ice_pellets_light.svg"),
            5101: ("Heavy Snow", "snow_heavy.svg"),
            5000: ("Snow", "snow.svg"),
            5100: ("Light Snow", "snow_light.svg"),
            5001: ("Flurries", "flurries.svg"),
            8000: ("Thunderstorm", "tstorm.svg"),
            2100: ("Light Fog", "fog_light.svg"),
            2000: ("Fog", "fog.svg"),
            1001: ("Cloudy", "cloudy.svg"),
            1102: ("Mostly Cloudy", "mostly_cloudy.svg"),
            1101: ("Partly Cloudy", "partly_cloudy_day.svg"),
            1100: ("Mostly Clear", "mostly_clear_day.svg"),
            1000: ("Clear", "clear_day.svg")
        ]
        return weatherCodes[statusCode] ?? ("Unknown Weather", "unknown.svg")
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Weather Data...")
                    
            } else {
                ZStack{
                    Image("App_background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                VStack {
                    let weatherInfo = weatherVM.getWeatherDescriptionAndIcon(for: weatherVM.statusCode)
                    HStack{
                        Spacer()
                        Button(action: {
                            toggleFavorite()
                        }) {
                            Image(systemName: isFavorite ? "xmark.circle.fill" : "plus.circle.fill") // "+" or "x"
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white) // Red for "x", Green for "+"
                        }
                        .padding(.trailing, 29)
                    }
                    NavigationLink(
                        destination: TabbedWeatherView(
                            city: weatherVM.cityName,
                            windSpeed: weatherVM.windSpeed,
                            pressure: weatherVM.pressure,
                            precipitation: weatherVM.precipitation,
                            temperature2: weatherVM.temperature2,
                            statusCode: weatherVM.statusCode,
                            humidity: weatherVM.humidity,
                            condition: weatherVM.getWeatherDescriptionAndIcon(for: weatherVM.statusCode).description,
                            visibility: weatherVM.visibility,
                            cloudCover: weatherVM.cloudCover,
                            uvIndex: weatherVM.uvIndex,
                            weeklyData: weatherVM.weeklyData
                        )
//                        .environmentObject(weatherVM)
                    ) {
                        let weatherInfo = weatherVM.getWeatherDescriptionAndIcon(for: weatherVM.statusCode)
                        WeatherBlockView(
                            temperature: "\(String(format: "%.0f", weatherVM.temperature2))°F",
                            condition: weatherInfo.description,
                            location: weatherVM.cityName,
                            weatherIcon: weatherInfo.description
                        )
                        .padding(.horizontal,28)
                    }
                    
      
                    
                    WeatherDetailsView(details: [
                        ("Humidity", "Humidity", "\(String(format: "%.0f", weatherVM.humidity))%"),
                        ("WindSpeed", "Wind Speed", "\(String(format: "%.2f", weatherVM.windSpeed)) mph"),
                        ("Visibility", "Visibility", "\(String(format: "%.2f", weatherVM.visibility)) mi"),
                        ("Pressure", "Pressure", "\(String(format: "%.2f", weatherVM.pressure)) inHg")
                    ])
                    .padding()
                    
                    WeatherTableView(weatherData: weatherVM.weatherTableData)
                    if showToast {
                                  VStack {
//                                      Spacer()
                                      ToastView(message: toastMessage)
                                          .padding(.bottom, 5) // Adjust bottom padding
                                  }
                                  .transition(.opacity)
                                  .animation(.easeInOut, value: showToast)
                                  .zIndex(3)
                              }
                    
                }.padding(.top,-60)
                    
            }
                .padding(.top,9)
                
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    onDisappear()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Weather")
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                Text(weatherVM.cityName ?? "Unknown City")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Right button tapped")
                    shareToTwitter(message: "The current temperature at \(city) is \(String(format: "%.0f", weatherVM.temperature2))°F. The weather conditions are \(weatherVM.condition) #CSCI571WeatherSearch")
                }) {
                    Image("twitter")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            SwiftSpinner.show("Fetching Weather Details for \(city)...")
            print("CityWeatherView appeared for city: \(city), state: \(state)")
            fetchCoordinatesAndWeather()
            checkIfFavorite()
        }
//        .onDisappear {
//                    onDisappear() // Reset navigation state on back
//                }
//
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
    
    private func fetchCoordinatesAndWeather() {
        // Construct URL using URLComponents
        var urlComponents = URLComponents(string: "http://127.0.0.1:3002/get-weather-city")
        urlComponents?.queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "state", value: state)
        ]


        guard let url = urlComponents?.url else {
                print("Failed to create URL from components")
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                    isLoading = false
                }
                return
            }

            print("Final URL: \(url)")

        print("Final URL: \(url)") // Debug statement

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch coordinates: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                    isLoading = false
                }
                return
            }

            do {
                let coordinates = try JSONDecoder().decode(CoordinatesResponse.self, from: data)
                print("Coordinates fetched: \(coordinates.latitude), \(coordinates.longitude)") // Debug statement
                DispatchQueue.main.async {
                    weatherVM.fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    SwiftSpinner.hide()
                    isLoading = false
                }
            } catch {
                print("Failed to decode coordinates: \(error)")
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                    isLoading = false
                }
            }
        }.resume()
    }
    func checkIfFavorite() {
         guard let url = URL(string: "http://127.0.0.1:3002/api/favorites") else { return }

         URLSession.shared.dataTask(with: url) { data, response, error in
             if let error = error {
                 print("Error fetching favorites: \(error.localizedDescription)")
                 isLoading = false
                 SwiftSpinner.hide()
                 return
             }

             guard let data = data else {
                 print("No data received")
                 isLoading = false
                 SwiftSpinner.hide()
                 return
             }

             do {
                 let favorites = try JSONDecoder().decode([Favorite].self, from: data)
                 DispatchQueue.main.async {
                     isFavorite = favorites.contains { $0.city == city && $0.state == state }
                     isLoading = false
                     SwiftSpinner.hide()
                 }
             } catch {
                 print("Error decoding favorites: \(error.localizedDescription)")
                 isLoading = false
                 SwiftSpinner.hide()
             }
         }.resume()
     }
    
    func toggleFavorite() {
            if isFavorite {
                // Remove from favorites (DELETE request)
                guard let url = URL(string: "http://127.0.0.1:3002/api/favorites?city=\(city)&state=\(state)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }

                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"

                URLSession.shared.dataTask(with: request) { _, response, error in
                    if let error = error {
                        print("Error deleting favorite: \(error.localizedDescription)")
                        return
                    }

                    DispatchQueue.main.async {
                        isFavorite = false
                        showToastMessage("\(city) was removed from the Favorite List")
                    }
                }.resume()
            } else {
                // Add to favorites (POST request)
                guard let url = URL(string: "http://127.0.0.1:3002/api/favorites") else { return }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let body: [String: String] = ["city": city, "state": state]
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)

                URLSession.shared.dataTask(with: request) { _, response, error in
                    if let error = error {
                        print("Error adding favorite: \(error.localizedDescription)")
                        return
                    }

                    DispatchQueue.main.async {
                        isFavorite = true
                        showToastMessage("\(city) was added to the Favorite List")
                    }
                }.resume()
            }
        }
    
    func showToastMessage(_ message: String) {
            toastMessage = message
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showToast = false
            }
        }
}

// Model for Decoding Coordinates Response
struct CoordinatesResponse: Codable {
    let latitude: Double
    let longitude: Double
}

struct Favorite: Codable, Identifiable {
    let id: String?
    let city: String
    let state: String
}
struct ToastView: View {
    var message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .foregroundColor(.white)
            .shadow(radius: 4)
    }
}
