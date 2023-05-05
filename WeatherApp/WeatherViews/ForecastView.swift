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
            
            Image("background2")
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
            VStack {
                Spacer()
                ///display the location name
                Text(modelData.location?.name ?? "No location available")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                ///For all the available daily data, they will be displayed using the DailyView() View
                List {
                    ForEach(modelData.forecast!.daily) { day in
                        DailyView(day: day)

                    }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .background {
                        Color.white
                                .opacity(0.3)
                    }
                }

                    .background {
                    Color.white
                            .opacity(0.6)
                }
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
