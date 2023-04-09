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
    @State var location = ""
    var body: some View {
        Spacer()
        ZStack {
            Color.teal
                .ignoresSafeArea()

            VStack {
                TextField("Enter New Location", text: self.$location, onCommit: {

                    CLGeocoder().geocodeAddressString(location) { (placemarks, error) in


                        if let lat = placemarks?.first?.location?.coordinate.latitude,
                            let lon = placemarks?.first?.location?.coordinate.longitude {
                            Task {
                                do {
                                    try await modelData.loadData(lat: lat, lon: lon)
                                    try await modelData.loadAirData(lat: lat, lon: lon)
                                } catch {
                                    print(error)
                                }
                            }
                            dismiss()
                        }


                    }//GEOCorder
                } //Commit

                )// TextField
                .padding(10)
                    .shadow(color: .blue, radius: 10)
                    .cornerRadius(10)
                    .fixedSize()
                    .font(.custom("Ariel", size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //.background(Color("background"))
                .cornerRadius(15) // TextField

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
