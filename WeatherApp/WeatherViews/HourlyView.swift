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
            Image(decorative: modelData.getImageName())
                .resizable()
                .ignoresSafeArea()
            ///The following VStack will display the name of the location of the data
            ///and then display the hourly condition using the HourCondition view
            ///
            VStack {
                Spacer()
                Text(modelData.location?.name ?? "No location available")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                List {
                    ForEach(modelData.forecast!.hourly) { hour in

                        HourCondition(current: hour)
                    }
                    ///used to format the conditionView inside the list
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)

                        .background {
                        Color.white
                            .opacity(0.6)
                    }

                }
                    .foregroundColor(.black)
            }
                .scrollContentBackground(.hidden)

        }
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView().environmentObject(ModelData())
    }
}
