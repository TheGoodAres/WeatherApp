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
                .tag(0)
            CurrentWeatherView()
                .tabItem {
                VStack {
                    Image(systemName: "sun.max")
                    Text("WeatherNow")
                }
            }
                .tag(1)

            HourlyView()
                .tabItem {
                VStack {
                    Image(systemName: "clock.fill")
                    Text("Hourly Summary")
                }
            }
                .tag(2)
            ForecastView()
                .tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("Forecast")
                }
            }
                .tag(3)
            PollutionView()
                .tabItem {
                VStack {
                    Image(systemName: "aqi.high")
                    Text("Pollution")
                }
            }
                .tag(4)
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
