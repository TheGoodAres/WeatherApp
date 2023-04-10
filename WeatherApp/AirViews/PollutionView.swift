//
//  PollutionView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 09/04/2023.
//

import SwiftUI

struct PollutionView: View {
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .opacity(0.8)

                .ignoresSafeArea()
            VStack {
                VStack {
                    Spacer()
                    Text(modelData.location?.name ?? "No location available")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .padding()
                    VStack {
                        HStack {
                            Label {
                                Text(modelData.forecast?.current.weather[0].weatherDescription.rawValue.capitalized ?? "No description available")
                                    .foregroundColor(.black)
                            } icon: {
                                IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                            }
                        }
                        VStack {
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
                    VStack {
                        Text("Air Quality Data:")
                    }
                        .font(.system(size: 40, weight: .heavy))
                    HStack {
                        Label {
                            Text("\(modelData.airQuality?.list[0].components.no2.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("so2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }.labelStyle(VerticalLabelStyle())
                            .padding()

                        Label {
                            Text("\(modelData.airQuality?.list[0].components.no.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("no")
                                .resizable()
                                .scaledToFit()

                                .frame(width: 50, height: 50)
                        }.labelStyle(VerticalLabelStyle())
                            .padding()

                        Label {
                            Text("\(modelData.airQuality?.list[0].components.co.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("voc")
                                .resizable()
                                .scaledToFit()

                                .frame(width: 50, height: 50)
                        }.labelStyle(VerticalLabelStyle())
                            .padding()

                        Label {
                            Text("\(modelData.airQuality?.list[0].components.pm2_5.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("pm")
                                .resizable()
                                .scaledToFit()

                                .frame(width: 50, height: 50)
                        }.labelStyle(VerticalLabelStyle())
                            .padding()
                    }

                    Spacer()
                }
            }
            .foregroundColor(.black)
            .shadow(color:.black, radius:0.5)
        }.ignoresSafeArea()
    }
}

struct PollutionView_Previews: PreviewProvider {
    static var previews: some View {
        PollutionView().environmentObject(ModelData())
    }
}