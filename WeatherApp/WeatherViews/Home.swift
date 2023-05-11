//
//  Home.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI
import CoreLocation

struct Home: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var modelData: ModelData

    @State var isSearchOpen = false
    @State var showLocationSettingsAlert = false

    var body: some View {
        ZStack {
            Image(decorative: modelData.getImageName())
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Spacer()

                HStack {
                    ///When the button is pressed,  it will open the SearchView used to change the location of the data
                    Button {
                        isSearchOpen = true
                    } label: {
                        Text("Change location")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .bold()
                    }
                    ///When the button is pressed, if location manager authorization status is denied or restricted, it will prompt the user to give permission
                    ///otherwise, it will load the current location data for the usera
                    Button {
                        if (locationManager.locationManager.authorizationStatus == .denied || locationManager.locationManager.authorizationStatus == .restricted) {
                            showLocationSettingsAlert = true
                        } else {
                            print("current location used")
                            modelData.currentLocationDisabled = false
                            Task {
                                await modelData.loadCurrentLocationData(locationManager: locationManager)
                            }
                        }
                    } label: {
                        ///when the current location is turned on (searchedCity == false), the icon will be a circle with an arrow
                        ///when the current location is turned off (searchedCity == true), the presivious icon will be slashed
                        Image(systemName: modelData.currentLocationDisabled ? "location.slash.circle" : "location.circle")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }
                        .accessibilityLabel("Use current location")
                }
                Spacer()
                /// location name and formatted date of the data
                VStack {
                    Spacer()
                    Text(modelData.location?.name ?? "No location available")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                    Text(getFormattedDate(from: modelData.forecast?.current.dt ?? 0, type: 0))
                        .font(.title)
                        .bold()
                    Spacer()
                }
                Spacer()
                ///current temperature, humidity and pressure
                VStack {
                    Spacer()
                    Text("Temp: \(modelData.forecast?.current.temp.rounded().formatted() ?? "0")°C")
                        .accessibilityLabel("Temperature: \(modelData.forecast?.current.temp.rounded().formatted() ?? "0")°C")
                    Spacer()
                    Text("Humidity: \(modelData.forecast?.current.humidity ?? 0) %")
                    Spacer()
                    Text("Pressure: \(modelData.forecast?.current.pressure ?? 0) hPa")
                        .accessibilityLabel("Pressure: \(modelData.forecast?.current.pressure ?? 0) hectoPascals")
                    Spacer()
                }
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.semibold/*@END_MENU_TOKEN@*/)
                ///weather description and icon
                HStack {
                    Label {
                        Text(modelData.forecast?.current.weather[0].weatherDescription.rawValue.capitalized ?? "Weather description unavailable")
                    } icon: {
                        IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                    }
                }
                    .fontWeight(.medium)
            }
            .foregroundColor(.black)

        }

            .sheet(isPresented: $isSearchOpen) {
            SearchView()
        }
        ///when this alert it's shown, it alerts that the app does not have permission to access the user's location. If guides the user to how to enable the permission, if the user presses the "Open Settings" button, the system app main page is opened.
        .alert(isPresented: $showLocationSettingsAlert) {
            Alert(
                title: Text("Location Access Required"),
                message: Text("Please enable location access for this app in Settings.\n Privacy & Security -> Location Services -> WeatherApp "),
                primaryButton: .default(Text("Open Settings"), action: openAppSettings),
                secondaryButton: .cancel()
            )
        }
            .onAppear {
            Task {
                if modelData.currentLocationDisabled {
                    do {
                        try await modelData.loadWeatherData(lat: modelData.forecast?.lat ?? 0, lon: modelData.forecast?.lon ?? 0)
                        try await modelData.loadAirData(lat: modelData.forecast?.lat ?? 0, lon: modelData.forecast?.lon ?? 0)
                    } catch {
                        print(error)
                    }
                } else {
                    await modelData.loadCurrentLocationData(locationManager: locationManager)
                }
            }
        }

    }
    ///When called, this function will take the user to the settings page
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(ModelData())
    }
}
