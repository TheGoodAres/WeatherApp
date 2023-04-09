//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 09/04/2023.
//

import SwiftUI


struct ForecastView: View {
    @EnvironmentObject var modelData: ModelData
    @State var locationString: String = "No location"
    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
            VStack {
                Text(modelData.location?.name ?? "No location available")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

                List {
                    ForEach(modelData.forecast!.daily) { day in
                        DailyView(day: day)

                    }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .background {
                        Color.white
                            .opacity(0.2)
                    }
                }
            
                .background{
                    Color.white
                        .opacity(0.5)
                }
                    .scrollContentBackground(.hidden)
            }
        }

            .onAppear {
            Task.init {
                self.locationString = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)

            }
        }
    }
}

struct Forecast_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView().environmentObject(ModelData())
    }
}
