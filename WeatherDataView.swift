//
//  WeatherDataView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation

import Foundation
import SwiftUI
import Highcharts

struct WeatherDataView: View {
    var humidity: Double
    var cloudCover: Double
    var precipitation: Int

    var body: some View {
        ScrollView {
        ZStack {
            // Background image
            Image("App_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            VStack(spacing: 20) { // Use VStack to stack components vertically
                // Weather Details Block
                VStack() {
                    HStack(spacing: 90) {
                        Image("Precipitation") // Icon on the left
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 30)
                        
                        Text("Precipitation: \(precipitation) %")
                            .font(.system(size: 20))
                            .lineLimit(1)
                            .padding(.trailing,10)// Ensure the text stays on one line
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Align items to the leading edge
                    
                    HStack(spacing: 109) {
                        Image("Humidity") // Icon on the left
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 30)
                        
                        Text("Humidity: \(Int(humidity)) %")
                            .font(.system(size: 20))
                            .lineLimit(1) // Ensure the text stays on one line
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Align items to the leading edge
                    
                    HStack(spacing: 74) {
                        Image("CloudCover") // Icon on the left
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 30)
                        
                        Text("Cloud Cover: \(String(format: "%.0f", cloudCover)) %")
                            .font(.system(size: 20))
                            .lineLimit(1) // Ensure the text stays on one line
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Align items to the leading edge
                }
                .padding() // Add padding to the entire VStack
                .frame(maxWidth: 350)
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
                .shadow(radius: 4)
                
                
                // Add spacer to ensure proper separation
                
                WeatherHighChartsWrapper(
                    humidity: humidity,
                    cloudCover: cloudCover,
                    precipitation: precipitation)
                .frame(height: 400)
                .padding(.top,30)// Ensure this matches your intended size
                
            }
            
        }
        }.padding(.top,-60)
    }
}



struct WeatherHighChartsWrapper: UIViewRepresentable {
    var humidity: Double
    var cloudCover: Double
    var precipitation: Int

    func makeUIView(context: Context) -> HIChartView {
        let chartView = HIChartView(frame: .zero)
        chartView.plugins = ["solid-gauge"]

        // Chart Configuration
        let options = HIOptions()

        // Chart Title
        let title = HITitle()
        title.text = "Weather Data"
        title.style = HICSSObject()
        title.style.fontSize = "24px"
        options.title = title

        // Pane Configuration
        let pane = HIPane()
        pane.startAngle = 0
        pane.endAngle = 360

        // Backgrounds for concentric circles
        let background1 = HIBackground()
        background1.backgroundColor = HIColor(rgba: 130, green: 238, blue: 106, alpha: 0.35)
        background1.outerRadius = "112%"
        background1.innerRadius = "88%"
        background1.borderWidth = 0

        let background2 = HIBackground()
        background2.backgroundColor = HIColor(rgba: 106, green: 165, blue: 231, alpha: 0.35) // Blue
        background2.innerRadius = "63%"
        background2.borderWidth = 0

        let background3 = HIBackground()
        background3.backgroundColor = HIColor(rgba: 255, green: 102, blue: 102, alpha: 0.35) // Pinkish Red
        background3.outerRadius = "62%"
        background3.innerRadius = "38%"
        background3.borderWidth = 0

        pane.background = [background1, background2, background3]
        options.pane = [pane]

        // Y-Axis Configuration
        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.max = 100
        yAxis.lineWidth = 0
        yAxis.tickPositions = []
        options.yAxis = [yAxis]

        // Plot Options
        let plotOptions = HIPlotOptions()
        plotOptions.solidgauge = HISolidgauge()
        let dataLabels = HIDataLabels()
        dataLabels.enabled = false
        plotOptions.solidgauge.dataLabels = [dataLabels]
        plotOptions.solidgauge.linecap = "round"
        plotOptions.solidgauge.stickyTracking = false
        plotOptions.solidgauge.rounded = true
        options.plotOptions = plotOptions

        // Series for Cloud Cover
        let cloudCoverSeries = HISolidgauge()
        cloudCoverSeries.name = "Cloud Cover"
        let cloudCoverData = HIData()
        cloudCoverData.color = HIColor(rgba: 130, green: 238, blue: 106, alpha: 1) // Green
        cloudCoverData.radius = "112%"
        cloudCoverData.innerRadius = "88%"
        cloudCoverData.y = NSNumber(value: cloudCover)
        cloudCoverSeries.data = [cloudCoverData]

        // Series for Precipitation
        let precipitationSeries = HISolidgauge()
        precipitationSeries.name = "Precipitation"
        let precipitationData = HIData()
        precipitationData.color = HIColor(rgba: 106, green: 165, blue: 231, alpha: 1) // Blue
        precipitationData.radius = "87%"
        precipitationData.innerRadius = "63%"
        precipitationData.y = NSNumber(value: precipitation)
        precipitationSeries.data = [precipitationData]

        // Series for Humidity
        let humiditySeries = HISolidgauge()
        humiditySeries.name = "Humidity"
        let humidityData = HIData()
        humidityData.color = HIColor(rgba: 255, green: 102, blue: 102, alpha: 1)
        humidityData.radius = "62%"
        humidityData.innerRadius = "38%"
        humidityData.y = NSNumber(value: humidity)
        humiditySeries.data = [humidityData]

        options.series = [cloudCoverSeries, precipitationSeries, humiditySeries]

        chartView.options = options
        return chartView
    }

    func updateUIView(_ uiView: HIChartView, context: Context) {}
}




//struct Previews_WeatherDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherDataView()
//    }
//}
