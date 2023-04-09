//
//  DailyView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 09/04/2023.
//

import SwiftUI

struct DailyView: View {
    var day: Daily
    var body: some View {
        VStack {

            HStack {
                IconFromWebsite(url: day.weather[0].icon)
                
                Spacer()
                VStack {
                    Text(day.weather[0].weatherDescription.rawValue.capitalized)

                    Text(getFormattedDate(from: day.dt, type: 3))

                }
                Spacer()
                Text("\(day.temp.max.rounded().formatted())°C/\(day.temp.min.rounded().formatted())°C")

            }
                .padding(25)
        }
    }

}

struct DailyView_Previews: PreviewProvider {
    static var day = ModelData().forecast!.daily

    static var previews: some View {
        DailyView(day: day[0])
    }
}
