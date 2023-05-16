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
            Image(decorative:modelData.getImageName())
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text(modelData.location?.name ?? "No location available")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                VStack {
                    Text("\((Int)(modelData.forecast!.current.temp))ºC")
                        .padding()
                        .font(.largeTitle)
                    VStack {
                        Label {
                            Text(modelData.forecast!.current.weather[0].weatherDescription.rawValue.capitalized)

                        } icon: {
                            IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                        }
                    }
                    VStack {
                        ///high, low and feels like temperature
                        VStack(spacing: 40) {

                            HStack {
                                Spacer()
                                Text("High: \(modelData.forecast?.daily[0].temp.max.rounded().formatted() ?? "0")ºC")
                                Spacer()
                                Text("Low: \(modelData.forecast?.daily[0].temp.min.rounded().formatted() ?? "0")ºC")
                                Spacer()
                            }
                            Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                        }
                            .font(.title3)
                            .fontWeight(.semibold)
                    }

                        .padding(.top, 50.0)
                    Spacer()
                    VStack(spacing: 30) {
                        ///wind speed, direction, humidity and pressure
                        Group {
                            VStack(spacing: 50) {
                                HStack {
                                    Spacer()
                                    Text("Wind Speed: \(modelData.forecast!.current.windSpeed.formatted()) m/s")
                                        .accessibilityLabel("Wind Speed: \(modelData.forecast!.current.windSpeed.formatted()) meters per second")
                                    Spacer()
                                    Text("Direction: \(convertDegToCardinal(deg: modelData.forecast!.current.windDeg))")
                                        .accessibilityLabel("Direction: \(returnLongCardinal(cardinal: convertDegToCardinal(deg: modelData.forecast!.current.windDeg))) " )
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text("Humidity: \(modelData.forecast!.current.humidity)%")
                                    Spacer()
                                    Text("Pressure: \(modelData.forecast!.current.pressure) hPg")
                                        .accessibilityLabel("Pressure: \(modelData.forecast!.current.pressure) hectoPascals")
                                    Spacer()
                                }
                            }
                                .font(.title3)
                                .padding(.bottom, 50.0)
                        }
                        ///sunset and sunrise times and icons
                        HStack {
                            Spacer()
                            Group{
                                Image(systemName: "sunset.fill").renderingMode(.original)
                                    .accessibilityHidden(true)
                                Text(getFormattedDate(from: modelData.forecast!.current.sunset ?? 0, type: 1))
                            }
                            .accessibilityLabel("Sunset at: \(getFormattedDate(from: modelData.forecast?.current.sunset ?? 0, type: 1))")
                            Spacer()
                            Group{
                                Image(systemName: "sunrise.fill").renderingMode(.original)
                                    .accessibilityHidden(true)
                                Text(getFormattedDate(from: modelData.forecast?.current.sunrise ?? 0, type: 1))
                            }
                            .accessibilityLabel("Sunrise at: \(getFormattedDate(from: modelData.forecast!.current.sunrise ?? 0, type: 1))")
                            Spacer()
                        }
                        .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                        Group{
                            Text(uvIntensity(index: modelData.forecast!.current.uvi))
                           
                        }.font(.title3)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
            }
            .foregroundColor(.black)
                .fontWeight(.medium)
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView().environmentObject(ModelData())
    }
}
