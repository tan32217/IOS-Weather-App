//
//  CitySearchView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation
import SwiftUI

struct CitySearchView: UIViewControllerRepresentable {
    @Binding var searchText: String
    @EnvironmentObject var weatherVM: WeatherViewModel // Access shared WeatherViewModel
    var onCitySelected: (String, String) -> Void // Closure for city selection
   
    
    func makeUIViewController(context: Context) -> DropdownViewController {
        let viewController = DropdownViewController()
        viewController.searchText = $searchText
        viewController.onCitySelected = onCitySelected // Pass closure correctly
        return viewController
    }

        func updateUIViewController(_ uiViewController: DropdownViewController, context: Context) {
            uiViewController.searchText = $searchText
        }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

    class Coordinator: NSObject, UITableViewDelegate {
        var parent: CitySearchView
        
        init(_ parent: CitySearchView) {
            self.parent = parent
        }
        
    }
    
}



class DropdownViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var searchText: Binding<String>!
    var onCitySelected: ((String, String) -> Void)? // Closure for city selection
    private let placesService = PlacesAutocompleteService()
    private var filteredCities: [String] = []
    private let searchBar = UISearchBar()
    private let tableView = UITableView()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Configure Search Bar
        searchBar.placeholder = "Search Cities"
        searchBar.delegate = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tableView.layer.zPosition = 10
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        // Configure Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 8
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
//        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.addSubview(tableView)


        // Bring tableView to the front
        view.bringSubviewToFront(tableView)

        // Layout Constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("in func searchbar")
        guard !searchText.isEmpty else {
            filteredCities = []
            tableView.isHidden = true
            tableView.reloadData()
            return
        }

        placesService.fetchAutocompleteSuggestions(for: searchText) { [weak self] suggestions in
            DispatchQueue.main.async {
                self?.filteredCities = suggestions
                print("Filtered cities: \(self?.filteredCities ?? [])")
                self?.tableView.isHidden = suggestions.isEmpty
                self?.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = filteredCities[indexPath.row]
        cell.selectionStyle = .default
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.black
        return cell
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCities[indexPath.row]
        print(selectedCity)
        let components = selectedCity.split(separator: ",")
        guard components.count >= 2 else { return }
        print("in row selected func")
        let city = components[0].trimmingCharacters(in: .whitespaces)
        let state = components[1].trimmingCharacters(in: .whitespaces)

        onCitySelected?(city, state)
        searchBar.text = ""
        searchText.wrappedValue = ""
        tableView.isHidden = true
        filteredCities.removeAll()
        tableView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("Touches began on DropdownViewController")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: searchBar.frame.maxY + 5, width: view.bounds.width, height: 200)
            print("Updated TableView Frame: \(tableView.frame)")
        print("SearchBar frame: \(searchBar.frame)")
        print("TableView frame: \(tableView.frame)")
    }

}
