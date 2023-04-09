//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Spacer()
                Text(modelData.location?.name ?? "No location available")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Spacer()
                VStack {
                    Text("\((Int)(modelData.forecast!.current.temp))ºC")
                        .padding()
                        .font(.largeTitle)
                    VStack {
                        HStack {
                            Label {
                                Text(modelData.forecast!.current.weather[0].weatherDescription.rawValue.capitalized)
                                    .foregroundColor(.black)
                                
                            } icon: {
                                IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                            }
                        }
                    }
                    VStack {
                        VStack(spacing:50) {
                            
                            HStack {
                                Spacer()
                                Text("H: \(modelData.forecast?.daily[0].temp.max.rounded().formatted() ?? "0") ºC")
                                Spacer()
                                Text("L: \(modelData.forecast?.daily[0].temp.min.rounded().formatted() ?? "0") ºC")
                                Spacer()
                            }
                            Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                    VStack(spacing:10){
                        Group {
                            VStack(spacing:50) {
                                HStack {
                                    Spacer()
                                    Text("Wind Speed: \(modelData.forecast!.current.windSpeed.formatted())m/s")
                                    Spacer()
                                    Text("Direction: \(convertDegToCardinal(deg: modelData.forecast!.current.windDeg))")
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text("Humidity: \(modelData.forecast!.current.humidity)%")
                                    Spacer()
                                    Text("Pressure: \(modelData.forecast!.current.pressure) hPg")
                                    Spacer()
                                }
                            }
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "sunset.fill").renderingMode(.original)
                            Text(getFormattedDate(from: modelData.forecast!.current.sunset ?? 0, type: 1))
                            Spacer()
                            Image(systemName: "sunrise.fill").renderingMode(.original)
                            Text(getFormattedDate(from: modelData.forecast!.current.sunrise ?? 0, type: 1))
                            Spacer()
                        }
                        
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView().environmentObject(ModelData())
    }
}
