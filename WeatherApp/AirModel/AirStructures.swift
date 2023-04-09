//
//  AirStructures.swift
//  CourseWork2Starter-main
//
//  Created by Robert-Dumitru Oprea on 28/03/2023.
//  Partially created with quicktype.io adjusted to fit the purpose

import Foundation

// MARK: - AirQuality
struct AirQuality: Codable, Identifiable {
    var id = UUID()
    let coord: Coordinates
    let list: [ListData]
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double

}

struct ListData: Codable {
    let main: MainData
    let components: Components
    let dt: Int
}

struct MainData: Codable {
    let aqi: Int
}

struct Components: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double
}
