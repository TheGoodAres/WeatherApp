//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 09/04/2023.
//

import SwiftUI


struct ForecastView: View {
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        ZStack {
            
            Image(decorative: modelData.getImageName())
                .resizable()
                .ignoresSafeArea()
                .accessibilityLabel("Background image of a clear sky")
            VStack {
                Spacer()
                ///display the location name
                Text(modelData.location?.name ?? "No location available")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .accessibilityLabel("Location: \(modelData.location?.name ?? "No location Available")")
                ///For all the available daily data, they will be displayed using the DailyView() View
                List {
                    ForEach(modelData.forecast!.daily) { day in
                        DailyView(day: day)

                    }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .background {
                        Color.white
                                .opacity(0.6)
                    }
                }
                .foregroundColor(.black )
//                    .background {
//                    Color.white
//                            .opacity(0.4)
//                }
                    .scrollContentBackground(.hidden)
            }
        }
    }
}

struct Forecast_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView().environmentObject(ModelData())
    }
}
