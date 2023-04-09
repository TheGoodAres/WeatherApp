//
//  NavBar.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("City")
                }
            }
            CurrentWeatherView()
                .tabItem {
                VStack {
                    Image(systemName: "sun.max")
                    Text("WeatherNow")
                }
            }

            HourlyView()
                .tabItem {
                VStack {
                    Image(systemName: "clock.fill")
                    Text("Hourly Summary")
                }
            }
            ForecastView()
                .tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("Forecast")
                }
            }
            PollutionView()
                .tabItem {
                VStack {
                    Image(systemName: "aqi.high")
                    Text("Pollution")
                }
            }
        }.onAppear {
            UITabBar.appearance().isTranslucent = false
            
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
    }
}
