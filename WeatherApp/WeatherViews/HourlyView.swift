//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI

struct HourlyView: View {
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
            VStack {
                Text(modelData.location?.name ?? "No location available")
                    .multilineTextAlignment(.center)
                    .font(.title)
                List {
                    ForEach(modelData.forecast!.hourly) { hour in
                        HourCondition(current: hour)
                            .frame(width:350)
                    }
                        .frame(width: 350)
                        .listRowInsets(.init(top: 0, leading: 25, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .background {
                        Color.white
                            .opacity(0.1)
                    }

                }
                
                    .padding()
                    .background {
                    Color.white
                        .opacity(0.5)
                }
                    .scrollContentBackground(.hidden)
            }
        }
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView().environmentObject(ModelData())
    }
}
