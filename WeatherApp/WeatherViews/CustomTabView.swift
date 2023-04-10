//
//  CustoTabView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 10/04/2023.
//
import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Spacer()
            switch selectedTab {
            case 0:
                Home()
                    .transition(.slide)
            case 1:
                CurrentWeatherView()
                    .transition(.slide)
            case 2:
                HourlyView()
                    .transition(.slide)
            case 3:
                ForecastView()
                    .transition(.slide)
                case 4:
                    PollutionView()
                        .transition(.slide)
            default:
                EmptyView()
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: { withAnimation { selectedTab = 0 } }) {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("City")
                    }
                }
                Spacer()
                Button(action: { withAnimation { selectedTab = 1 } }) {
                    VStack {
                        Image(systemName: "sun.max")
                        Text("WeatherNow")
                    }
                }
                Spacer()
                Button(action: { withAnimation { selectedTab = 2 } }) {
                    VStack {
                        Image(systemName: "clock.fill")
                        Text("Hourly Summary")
                    }
                }
                Spacer()
                Button(action: {withAnimation{selectedTab = 3}} ) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Forecast")
                    }
                    
                }
                Spacer()
                Button(action: {withAnimation {selectedTab = 4}}) {
                    VStack {
                        Image(systemName: "aqi.high")
                        Text("Pollution")
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top )
        
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}

