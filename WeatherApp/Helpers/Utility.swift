//
//  Utility.swift
//  CourseWork2Starter
//
//  Created by Robert-Dumitru Oprea on 22/03/2023.
//
// utilities used throught the project

import Foundation
import SwiftUI

//function used to get the formatted date from the unix date returned by the api
func getFormattedDate(from date: Int, type: Int) -> String {
    let dateFormatter = DateFormatter()
    if(type == 0) {
        dateFormatter.dateFormat = "MMMM dd','yyyy 'at' HH a" //"month name" "day number", "year" at "hour number" "AM/PM(based on the time)" "April 25, 2023 at 08AM"
    } else if(type == 1) {
        dateFormatter.dateFormat = "HH:ss a"//"hour":"seconds" "AM/PM", "20:18 PM"
    } else if(type == 2) {
        dateFormatter.dateFormat = "HH a\n EE"//"hour" "AM/PM" "short day name", "09 AM Tue"
    } else if(type == 3) {
        dateFormatter.dateFormat = "EEEE dd" // "full day name" "date day number", "Tuesday 25"
    }
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    let date = NSDate(timeIntervalSince1970: TimeInterval(date))

    return dateFormatter.string(from: date as Date)
}

//struct used to get the async image from the website
struct IconFromWebsite: View {
    var url: String
    var body: some View {
        if let imageUrl = URL(string:"https://openweathermap.org/img/wn/\(url)@2x.png"){
            CustomAsyncImage(url: imageUrl)
            .frame(width:75, height: 75)
        } 
    }
}
// Struct used to customise the Label view, it makes the icon and the text stack vertically rather than horizontally
//credit to: https://medium.com/macoclock/make-more-with-swiftuis-label-94ef56924a9d
struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 8) {
            configuration.icon
            configuration.title
        }
    }
}



struct Location:Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    enum CodingKeys: String, CodingKey {
           case name
           case latitude
           case longitude
       }
}
