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
            Image("background2")
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer()
                HStack {
                    //Change location button
                    Button {
                        isSearchOpen = true
                        modelData.searchedCity = true
                    } label: {
                        Text("Change location")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .bold()
                    }
                    //use current user location button
                    Button {
                        if (locationManager.locationManager.authorizationStatus == .denied || locationManager.locationManager.authorizationStatus == .restricted) {
                            showLocationSettingsAlert = true
                        } else {
                            print("current location used")
                            modelData.searchedCity = false
                            Task {
                                await modelData.loadCurrentLocationData(locationManager: locationManager)
                            }
                        }
                    } label: {
                        //when the current location is turned on (searchedCity == false), the icon will be a circle with an arrow
                        //when the current location is turned off (searchedCity == true), the presivious icon will be slashed
                        Image(systemName: modelData.searchedCity ? "location.slash.circle" : "location.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                Spacer()
                VStack {
                    Spacer()
                    Text(modelData.location?.name ?? "No location available")
                        .font(.title)
                    Spacer()
                    Text(getFormattedDate(from: modelData.forecast?.current.dt ?? 0, type: 0))
                        .font(.title)
                        .bold()
                    Spacer()
                }
                Spacer()
                VStack {
                    Spacer()
                    Text("Temp: \(modelData.forecast?.current.temp.rounded().formatted() ?? "0")°C")
                    Spacer()
                    Text("Humidity: \(modelData.forecast?.current.humidity ?? 0) %")
                    Spacer()
                    Text("Pressure: \(modelData.forecast?.current.pressure ?? 0) hPa")
                    Spacer()
                }
                Spacer()
                HStack {
                    Label {
                        Text(modelData.forecast?.current.weather[0].weatherDescription.rawValue ?? "Weather description unavailable")
                    } icon: {
                        IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                    }
                }
            }
        }

            .sheet(isPresented: $isSearchOpen) {
            SearchView()
        }
            .alert(isPresented: $showLocationSettingsAlert) {
            Alert(
                title: Text("Location Access Required"),
                message: Text("Please enable location access for this app in Settings.\n Privacy & Security -> Location Services -> App name "),
                primaryButton: .default(Text("Open Settings"), action: openAppSettings),
                secondaryButton: .cancel()
            )
        }
            .task{
                modelData.loadUserDefaults()
            }


    }





    func openAppSettings() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(url)
//        }
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
