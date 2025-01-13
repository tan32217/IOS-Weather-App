//
//  WeatherBlockView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation

import SwiftUI

struct WeatherBlockView: View {
    var temperature: String
    var condition: String
    var location: String
    var weatherIcon: String // The name of the weather icon image in Assets

    var body: some View {
        HStack {
            // Weather Icon
            Image(weatherIcon)
                .resizable()
                .frame(width: 80, height: 80)
                .padding()

            // Weather Details
            VStack(alignment: .leading, spacing: 4) {
                Text(temperature)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)

                Text(condition)
                    .font(.system(size: 18))
                    .foregroundColor(.black)

                Text(location)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            }
            Spacer() // Push content to the left
        }
        .frame(maxWidth: .infinity) // Expand to fill the width
        .zIndex(2)
        .background(Color.white.opacity(0.3))
        .cornerRadius(12)
        .shadow(radius: 4)
       // Add a subtle shadow
    }
}

struct WeatherBlockView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherBlockView(
            temperature: "80°F",
            condition: "Cloudy",
            location: "Los Angeles",
            weatherIcon: "Mostly Clear" // Replace with your actual image name
        )

//        .background(Image("App_background")
//            .resizable()
//            .scaledToFill()
//            .ignoresSafeArea())
    }
}
