//import SwiftUI
//
//struct WeatherAppMainView: View {
//    @State private var favorites: [FavoriteCity1] = [] // To store favorite cities
//    private let favoritesService = FavoritesService()
//    @State private var triggerSearchReset: Bool = false // Reset flag for search bar
//        @State private var searchText: String = "" // To track search text
//    var body: some View {
//        TabView {
//            // Page 1: ContentView
//            ContentView()
//                .tabItem {
//                    Label("Weather", systemImage: "cloud.sun")
//                }.tag(0).id(UUID())
//            
////             Page 2: Static Example (for Debugging)
//            CityWeatherView(
//                city: "Los Angeles",
//                state: "CA",
//                triggerReset: $triggerSearchReset,
//                                searchText: $searchText,
//                onDisappear: {
//                    triggerSearchReset.toggle() // Reset search state when returning to ContentView
//                                        print("Static CityWeatherView disappeared.")
//                }
//            )
//            .tabItem {
//                Label("Example", systemImage: "star.circle")
//            }.id(UUID()) 
//            
//            // Dynamically load favorites
//            ForEach(favorites) { favorite in
//                CityWeatherView(
//                    city: favorite.city,
//                    state: favorite.state,
//                    triggerReset: $triggerSearchReset,
//                    searchText: $searchText,
//                    onDisappear: {
//                        triggerSearchReset.toggle() // Reset search state when returning to ContentView
//                                            print("Static CityWeatherView disappeared.")
//                    }
//                )
//                .tabItem {
//                    Label(favorite.city, systemImage: "star.circle.fill")
//                }
//            }
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//        .onAppear {
//            fetchFavorites()
//        }
//    }
//    
//    private func fetchFavorites() {
//        favoritesService.fetchFavorites { result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    // Directly assign the decoded favorites
//                    self.favorites = data.map { favorite in
//                        FavoriteCity1(id: favorite.id, city: favorite.city, state: favorite.state)
//                    }
//                }
//            case .failure(let error):
//                print("Failed to fetch favorites: \(error.localizedDescription)")
//            }
//        }
//    }
//
//}
//
//struct FavoriteCity1: Identifiable {
//    let id: String // Unique identifier
//    let city: String
//    let state: String
//}
//
//struct WeatherAppMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherAppMainView()
//    }
//}
//
