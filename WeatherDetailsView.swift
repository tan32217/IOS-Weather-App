//
//  WeatherDetailsView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation

import SwiftUI

struct WeatherDetailsView: View {
    var details: [(image: String, label: String, value: String)] // Accept dynamic data

    var body: some View {
        HStack(spacing: 1) {
            ForEach(details, id: \.label) { detail in
                VStack(spacing: 8) { // Reduced spacing for better alignment
                    // Label
                    Text(detail.label)
                        .font(.system(size: 14))
                        .foregroundColor(.black)

                    // Image
                    Image(detail.image) // Ensure the image exists in Assets.xcassets
                        .resizable()
                        .frame(width: 37, height: 37)

                    // Value
                    Text(detail.value)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)// Ensure equal space for each VStack
            }
        }
        .frame(height: 100) // Explicit height for fixed layout
         // Add subtle shadow
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsView(details: [
            ("Humidity", "Humidity", "89%"),
            ("WindSpeed", "Wind Speed", "12.02 mph"),
            ("Visibility", "Visibility", "9.94 mi"),
            ("Pressure", "Pressure", "29.92 inHg")
        ])
            .frame(width: 400) // Optional for preview
            .padding()
          // Optional preview background
    }
}
