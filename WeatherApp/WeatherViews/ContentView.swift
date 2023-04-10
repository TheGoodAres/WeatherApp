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
        ///The following ZStack shows the SplashView when isSplashActive is true, otherwise the NavBar view is shown
        ZStack {
            if isSplashActive {
                SplashView()
            } else {
                NavBar()
            }
        }
        ///when the authorizationStatus of the location manager is authorizeAlways or authorizedWhenInUse the ModelData will
        ///load the data for the current location of the user, it will also turn off the splashView
        ///If the authorizationStatus is anything else, ModelData will the data from the UserDefaults while also turning off the splashView

            .onChange(of: locationManager.authorizationStatus, perform: { newValue in
            Task {
                if (locationManager.locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.locationManager.authorizationStatus == .authorizedAlways) {
                    if(modelData.currentLocationDisabled) {
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
        ///When the scenePhase becomes inactive or bacground, the splashScreen will be enabled again
        ///When the scenePhase becomes active, the splashAction will be called
            .onChange(of: scenePhase) { newValue in
                switch newValue {
                    case .inactive, .background:
                                        // App is inactive or in the background
                                        isSplashActive = true
                    case .active:
                        splashAction()
                    default:
                        break
                }
                
            }
    }
    ///This function will present the user with the request to access their location when the authorization status is not determined
    ///otherwise, it will disable the splash screen
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
