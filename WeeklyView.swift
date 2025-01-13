//
//  WeeklyView.swift
//  WeatherInfo
//
//  Created by d22guest on 12/11/24.
//

import Foundation
import Foundation
import SwiftUI
import Highcharts

struct WeeklyView: View {
    let weeklyData: [(day: Int, minTemp: Double, maxTemp: Double)]
    var condition: String
    var temperature2:Double
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
                HStack(spacing:20) {
                    // Weather Icon
                    Image((condition))
                        .resizable()
                        .frame(width: 130, height: 130)
                        .padding(.horizontal,40)
                    
                    // Weather Details
                    VStack(alignment: .center, spacing: 4) {
                        Text((condition))
                            .font(.system(size: 23))
                            .padding()
                        
                        
                        Text("\(String(format: "%.0f", temperature2)) °F")
                            .font(.system(size: 35))
                        
                        
                    }
                }
                .frame(maxWidth: 350)
                .frame(maxHeight:200)
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
                .shadow(radius: 4)
                //                .padding()
                
                
                // Highcharts Wrapper for the Chart
                HighChartsWrapper(weeklyData: weeklyData)
                    .frame(maxHeight:330)
                    .frame(maxWidth: .infinity)
                
            }
            
            // Add padding to the entire VStack
        }
        
    }.padding(.top, -60)
       
    }
}


struct HighChartsWrapper: UIViewRepresentable {
    let weeklyData: [(day: Int, minTemp: Double, maxTemp: Double)] // Accept weeklyData as a parameter

    func makeUIView(context: Context) -> HIChartView {
        let chartView = HIChartView(frame: .zero)

        // Chart Configuration
        let options = HIOptions()

        // Chart Type
        let chart = HIChart()
        chart.type = "arearange" // Use arearange for filling between min and max
        options.chart = chart

        // Chart Title
        let title = HITitle()
        title.text = "Temperature Variation by Day"
        options.title = title

        // X-Axis
        let xAxis = HIXAxis()
        xAxis.categories = weeklyData.map { "\($0.day)" } // Use day numbers from weeklyData
//        xAxis.title = HITitle()
//        xAxis.title.text = "Days"
//        options.xAxis = [xAxis]

        // Y-Axis
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "Temperatures"
        yAxis.min = weeklyData.map { $0.minTemp }.min() as NSNumber? ?? 0 - 5 as NSNumber? // Set min dynamically
        yAxis.max = weeklyData.map { $0.maxTemp }.max() as NSNumber? ?? 0 + 5 as NSNumber? // Set max dynamically
        options.yAxis = [yAxis]

        // Area Gradient Color
        let gradientColor = HIColor(linearGradient: ["x1": 0, "x2": 0, "y1": 0, "y2": 1],
                                    stops: [
                                        [NSNumber(value: 0), "rgba(255, 165, 0, 0.5)"],
                                        [NSNumber(value: 1), "rgba(173, 216, 230, 0.5)"]
                                    ])

        // Temperature Range Series
        let tempRange = HIArearange()
        tempRange.name = ""
        tempRange.data = weeklyData.map { [$0.day - 1, $0.minTemp, $0.maxTemp] } // Map weeklyData to series
        tempRange.color = gradientColor
        tempRange.marker = HIMarker()
        tempRange.marker.fillColor = HIColor(name: "black")
        tempRange.marker.symbol = "circle"
        tempRange.marker.lineWidth = 1

        // Add Series to Options
        options.series = [tempRange]

        // Set options to the chart view
        chartView.options = options
        return chartView
    }

    func updateUIView(_ uiView: HIChartView, context: Context) {}
}

//struct Previews_WeeklyView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyView(weeklyData)
//    }
//}
