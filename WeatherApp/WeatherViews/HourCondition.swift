//
//  HourCondition.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 08/04/2023.
//

import SwiftUI

struct HourCondition: View {
    var current:Current
    
    var body: some View {
        VStack{
            HStack{
                Text(getFormattedDate(from:current.dt, type: 2))
                Spacer()
                IconFromWebsite(url: current.weather[0].icon)
                Text("\(current.temp.rounded().formatted()) ºC")
                Spacer()
                VStack{
                    Text(current.weather[0].weatherDescription.rawValue.capitalized)
                        .multilineTextAlignment(.leading)
                }
//                .padding(.trailing)
            }
            .padding(25)
        }
    }
}

struct HourCondition_Previews: PreviewProvider {
    static var previews: some View {
        HourCondition(current: ModelData().forecast!.hourly[0])
    }
}
