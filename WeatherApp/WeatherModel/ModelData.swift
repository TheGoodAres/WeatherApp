//
//  ModelData.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import Foundation

class ModelData: ObservableObject {
    @Published var forecast: Forecast?
    @Published var airQuality: AirQuality?
    @Published var location: Location?
    @Published var currentLocationDisabled = false
    @Published var dataLoaded = false
    @Published var lastFetchDate: Date?
    let oneHour: TimeInterval = 60 * 60

    let apiKey = "d23f70c3225fd0fa59564d2ffaded0fa"

    init() {
        loadUserDefaults()
        print(lastFetchDate)
    }

    //function used to load the data from UserDefaults
    //if UserDefaults does not hold any data, then it will load from the stock data in the 2 JSON files, london.json and air_pollution.json
    func loadUserDefaults() {
        var forecastAvailable = false
        var airQualityAvailable = false
        var locationAvailable = false
        var availableUserDefaults: Bool {
            get {
                forecastAvailable && airQualityAvailable && locationAvailable
            }
        }


        if let savedForecast = UserDefaults.standard.data(forKey: "forecast") {
            if let decodedItems = try? JSONDecoder().decode(Forecast.self, from: savedForecast) {
                forecast = decodedItems
                forecastAvailable = true

            }
        }
        if let savedAirQuality = UserDefaults.standard.data(forKey: "airQuality") {
            if let decodedItems = try? JSONDecoder().decode(AirQuality.self, from: savedAirQuality) {
                airQuality = decodedItems
                airQualityAvailable = true

            }
        }

        if let savedLocation = UserDefaults.standard.data(forKey: "location") {
            if let decodedItems = try? JSONDecoder().decode(Location.self, from: savedLocation) {
                location = decodedItems
                locationAvailable = true

            }
        }
        if let savedSearchedCity = UserDefaults.standard.data(forKey: "currentLocationDisabled") {
            if let decodedItems = try? JSONDecoder().decode(Bool.self, from: savedSearchedCity) {
                currentLocationDisabled = decodedItems
            }
        }
        if let savedLastFetchDate = UserDefaults.standard.data(forKey: "lastFetchedDate") {
            if let decodedItems = try? JSONDecoder().decode(Date.self, from: savedLastFetchDate) {
                lastFetchDate = decodedItems
            }
        } else {
            lastFetchDate = Date(timeIntervalSince1970: 0)
        }
        if (!availableUserDefaults) {
            self.forecast = load("london.json")
            self.airQuality = loadLocalAir("air_pollution.json")

            let lat = self.forecast?.lat ?? 0.0
            let lon = self.forecast?.lon ?? 0.0
            Task {
                await updateLocation(lat: lat, lon: lon)
                DispatchQueue.main.async {
                    self.dataLoaded = true
                }
            }
        }

    }
    //function used to save the current data to UserDefaults
    func saveToUserDefaults() {
        if let encodedForecast = try? JSONEncoder().encode(forecast) {
            UserDefaults.standard.set(encodedForecast, forKey: "forecast")
        }
        if let encodedAirQuality = try? JSONEncoder().encode(airQuality) {
            UserDefaults.standard.set(encodedAirQuality, forKey: "airQuality")
        }
        if let encodedLocation = try? JSONEncoder().encode(location) {
            UserDefaults.standard.set(encodedLocation, forKey: "location")
        }
        if let encodedSearchedCity = try? JSONEncoder().encode(currentLocationDisabled) {
            UserDefaults.standard.set(encodedSearchedCity, forKey: "currentLocationDisabled")
        }
        if let encodedLastFetchDate = try? JSONEncoder().encode(lastFetchDate) {
            UserDefaults.standard.set(encodedLastFetchDate, forKey: "lastFetchedDate")
        }
    }
    //The following 2 functions will load data from files
    func load<Forecast: Decodable>(_ filename: String) -> Forecast {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(Forecast.self):\n\(error)")
        }
    }
    func loadLocalAir<AirQuality: Decodable>(_ filename: String) -> AirQuality {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AirQuality.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(AirQuality.self):\n\(error)")
        }
    }
    //The following 2 functions will call the OpenWeather API and get the required data from it, once received, it will decode the data and then save it to UserDefaults
    func loadData(lat: Double, lon: Double) async throws -> Forecast {
        if shouldUpdate(lat: lat, lon: lon) {
            let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)")
            let session = URLSession(configuration: .default)

            let (data, _) = try await session.data(from: url!)

            do {
                let forecastData = try JSONDecoder().decode(Forecast.self, from: data)
                DispatchQueue.main.async {
                    self.forecast = forecastData

                    Task {
                        await self.updateLocation(lat: lat, lon: lon)

                        self.saveToUserDefaults()
                        self.dataLoaded = true
                        self.lastFetchDate = Date()

                        print("Data Loaded")
                    }
                }
                return forecastData
            } catch {
                print(error)
                throw error
            }
        } else {
            return self.forecast!
        }

    }
    func loadAirData(lat: Double, lon: Double) async throws -> AirQuality {
        if shouldUpdate(lat: lat, lon: lon) {

            let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)")
            let session = URLSession(configuration: .default)

            let (data, _) = try await session.data(from: url!)

            do {
                let airData = try JSONDecoder().decode(AirQuality.self, from: data)
                DispatchQueue.main.async {
                    self.airQuality = airData
                    self.saveToUserDefaults()
                    self.lastFetchDate = Date()

                }

                return airData
            } catch {
                print(error)
                throw error
            }

        } else {
            return self.airQuality!
        }
    }

    func loadCurrentLocationData(locationManager: LocationManager) async {
        if !currentLocationDisabled {
            if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.locationManager.authorizationStatus == .authorizedAlways {

                if let lat = locationManager.locationManager.location?.coordinate.latitude, let lon = locationManager.locationManager.location?.coordinate.longitude {
                    if shouldUpdate(lat: lat, lon: lon) {
                        do {
                            try await loadData(lat: lat, lon: lon)
                            await updateLocation(lat: lat, lon: lon)
                            DispatchQueue.main.async {
                                self.dataLoaded = true
                                self.lastFetchDate = Date()

                            }
                            print("CurrentLocationUpdated")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }


    func updateLocation(lat: Double, lon: Double) async {
        DispatchQueue.main.async {
            Task {
                let locationName = await getLocFromLatLong(lat: lat, lon: lon)
                let location = Location(name: locationName, latitude: lat, longitude: lon)
                self.location = location
                self.saveToUserDefaults()
            }
        }

    }

    func shouldUpdate(lat: Double, lon: Double) -> Bool {
        let currentDate = Date()
        print(currentDate.timeIntervalSince(lastFetchDate!) <= oneHour)
        print((location?.longitude == lon && location?.latitude == lat))
        if ((location?.longitude == lon && location?.latitude == lat) && (currentDate.timeIntervalSince(lastFetchDate!) <= oneHour)) {
            print("shouldNotUpdate")
            return false
        } else {
            print("Should Update")
            return true
        }
    }
}
