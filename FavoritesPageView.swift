//import SwiftUI
//
//struct FavoritesPageView: View {
//    @State private var currentIndex = 0
//    @State private var favoriteCities: [City] = []
//
//    var body: some View {
//        VStack {
//            if favoriteCities.isEmpty {
//                Text("No Favorites Added")
//                    .font(.title2)
//                    .foregroundColor(.gray)
//            } else {
//                // PageViewController with dynamically updated views
//                PageViewController(
//                    views: buildFavoriteCityViews(),
//                    currentIndex: $currentIndex
//                )
//                .frame(height: UIScreen.main.bounds.height * 0.85)
//
//                // Page Indicator
//                HStack {
//                    ForEach(0..<favoriteCities.count, id: \.self) { index in
//                        Circle()
//                            .fill(index == currentIndex ? Color.blue : Color.gray)
//                            .frame(width: 8, height: 8)
//                    }
//                }
//                .padding(.top, 10)
//            }
//        }
//        .onAppear(perform: fetchFavorites)
//    }
//
//    /// Dynamically build views for favorite cities
//    private func buildFavoriteCityViews() -> [UIViewController] {
//        favoriteCities.map { city in
//            UIHostingController(
//                rootView: CityWeatherView(
//                    city: city.name,
//                    state: city.state,
//                    onDisappear: fetchFavorites // Refresh favorites when a page is updated
//                )
//            )
//        }
//    }
//
//    /// Fetch the list of favorite cities from the server or data source
//    private func fetchFavorites() {
//        guard let url = URL(string: "http://127.0.0.1:3002/api/favorites") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//
//            do {
//                let cities = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
//                let parsedCities = cities?.compactMap { dict -> City? in
//                    guard let name = dict["city"] as? String,
//                          let state = dict["state"] as? String else { return nil }
//                    return City(name: name, state: state)
//                } ?? []
//
//                DispatchQueue.main.async {
//                    favoriteCities = parsedCities
//                }
//            } catch {
//                print("Error decoding favorites: \(error)")
//            }
//        }.resume()
//    }
//}
//
