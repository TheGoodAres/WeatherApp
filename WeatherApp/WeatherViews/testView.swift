//
//  testView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 13/05/2023.
//

import SwiftUI

struct testView: View {
    @ObservedObject var locationSearchService = LocationSearchService()
        @State var searchQuery = ""
        
        var body: some View {
            VStack {
                TextField("Search for a place", text: $searchQuery, onCommit: {
                    locationSearchService.searchQueryChanged(query: searchQuery)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                List(locationSearchService.searchResults, id: \.title) { result in
                    VStack(alignment: .leading) {
                        Text(result.title)
                        Text(result.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
}
