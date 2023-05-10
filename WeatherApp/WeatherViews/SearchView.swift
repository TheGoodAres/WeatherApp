//
//  SearchView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    @State private var displayError = false
    @State private var error: Error?
    @State var location = ""
    var body: some View {
        Spacer()
        ZStack {
            Color.teal
                .ignoresSafeArea()

            VStack {
                TextField("Enter New Location", text: self.$location, onCommit: {
                    ///the following will use CLGeocoder() to get the coordinates for a string address,
                    ///if the coordinates are returned, the weather data and the air pollution data will be loaded from the OpenWeather API
                    ///once that is done, the currentLocationDisabled variable will be set to true, disabling the updating of the data for the user's current location
                    ///the view will also dismiss itself once this is done
                    CLGeocoder().geocodeAddressString(location) { (placemarks, error) in


                        if let lat = placemarks?.first?.location?.coordinate.latitude,
                            let lon = placemarks?.first?.location?.coordinate.longitude {
                            Task {
                                do {
                                    try await modelData.loadWeatherData(lat: lat, lon: lon)
                                    try await modelData.loadAirData(lat: lat, lon: lon)
                                } catch {
                                    print(error)
                                    self.error = error
                                    self.displayError = true
                                }
                            }
                            modelData.currentLocationDisabled = true
                            dismiss()
                        }
                        print(error as Any)
                        self.error = error
                        self.displayError = true

                    }//GEOCorder
                } //Commit

                )// TextField
                .padding(10)
                    .shadow(color: .blue, radius: 10)
                    .cornerRadius(10)
                    .fixedSize()
                    .font(.custom("Ariel", size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(15) // TextField
                if displayError {
                    Group {
                        Text("\(error?.localizedDescription ?? "Unknown Error") Please contact the developer.")

                        Button("Dismiss") {
                            displayError = false
                            error = nil
                        }
                    }
                        .padding()
                        .background() {
                        Color.gray
                            .opacity(0.2)
                    }
                }
            }//VStak


        }// Zstack
        Spacer()
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
