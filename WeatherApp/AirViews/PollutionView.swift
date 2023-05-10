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
                VStack(spacing: 40) {
                    Spacer()
                    Text(modelData.location?.name ?? "No location available")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .padding()
                    Text("\(modelData.forecast?.current.temp.rounded().formatted() ?? "0")ºC")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .padding()
                    VStack(spacing: 20) {
                        HStack {
                            Label {
                                Text(modelData.forecast?.current.weather[0].weatherDescription.rawValue.capitalized ?? "No description available")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            } icon: {
                                IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                            }
                        }
                        VStack(spacing: 40) {
                            HStack {
                                Spacer()
                                Text("High: \(modelData.forecast?.daily[0].temp.max.rounded().formatted() ?? "0") ºC")
                                Spacer()
                                Text("Low: \(modelData.forecast?.daily[0].temp.min.rounded().formatted() ?? "0") ºC")
                                Spacer()
                            }
                            Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                                .foregroundColor(.black)
                        }
                            .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.semibold/*@END_MENU_TOKEN@*/)

                        Text("Air Quality Data:")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.vertical, 10.0)
                    }
                    HStack {
                        Label {
                            Text("\(modelData.airQuality?.list[0].components.no2.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("so2")
                                .resizable()
                                .frame(width: 65, height: 65)
                        }
                            .labelStyle(VerticalLabelStyle())
                            .padding()
                            .accessibilityLabel("Sulfur Dioxide:\(modelData.airQuality?.list[0].components.no2.rounded().formatted() ?? "0.0") ")

                        Label {
                            Text("\(modelData.airQuality?.list[0].components.no.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("no")
                                .resizable()
                                .frame(width: 65, height: 65)
                        }
                            .labelStyle(VerticalLabelStyle())
                            .padding()
                            .accessibilityLabel("Nitric Oxide: \(modelData.airQuality?.list[0].components.no.rounded().formatted() ?? "0.0")")

                        Label {
                            Text("\(modelData.airQuality?.list[0].components.co.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("voc")
                                .resizable()
                                .frame(width: 65, height: 65)
                        }
                            .labelStyle(VerticalLabelStyle())
                            .padding()
                            .accessibilityLabel("Volatile Organic Compounds: \(modelData.airQuality?.list[0].components.co.rounded().formatted() ?? "0.0")")

                        Label {
                            Text("\(modelData.airQuality?.list[0].components.pm2_5.rounded().formatted() ?? "0.0")")
                        } icon: {
                            Image("pm")
                                .resizable()
                                .frame(width: 65, height: 65)
                        }
                            .labelStyle(VerticalLabelStyle())
                            .padding()
                            .accessibilityLabel("Promethium: \(modelData.airQuality?.list[0].components.pm2_5.rounded().formatted() ?? "0.0")")
                    }

                    Spacer()
                }
            }
                .foregroundColor(.black)
                .shadow(color: .black, radius: 0.5)
        }.ignoresSafeArea()
    }
}

struct PollutionView_Previews: PreviewProvider {
    static var previews: some View {
        PollutionView().environmentObject(ModelData())
    }
}
