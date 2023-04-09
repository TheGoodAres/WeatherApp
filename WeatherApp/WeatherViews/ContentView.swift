//
//  ContentView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var modelData: ModelData
    @State private var isSplashActive = true
    var body: some View {
        ZStack {
            if isSplashActive {
                SplashView()
            } else {
                NavBar()
            }
        }
            .onChange(of: locationManager.authorizationStatus, perform: { newValue in
            Task {
                if (locationManager.locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.locationManager.authorizationStatus == .authorizedAlways) {
                    if(modelData.searchedCity) {
                        await modelData.loadCurrentLocationData(locationManager: locationManager)
                        withAnimation{
                            isSplashActive = false
                        }
                        
                    }
                }
                else {
                    modelData.loadUserDefaults()
                    withAnimation{
                        isSplashActive = false
                    }
                }
            }
        })
            .onChange(of: scenePhase) { newValue in
                switch newValue {
                    case .inactive, .background:
                                        // App is inactive or in the background
                                        isSplashActive = true
                    case.active:
                        splashAction()
                    default:
                        break
                }
                
            }
            .task {

            splashAction()


        }
    }
    func splashAction() {
        if(locationManager.locationManager.authorizationStatus == .notDetermined) {
            locationManager.locationManager.requestWhenInUseAuthorization()
        } else {
            Task{
                withAnimation{
                    isSplashActive = false
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}
