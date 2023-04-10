//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var modelData = ModelData()
    @StateObject var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
//            CustomTabView()
                .environmentObject(modelData)
                .environmentObject(locationManager)
        }
    }
}
