//
//  LocationSearchSevice.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 13/05/2023.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
   @Published var searchResults = [MKLocalSearchCompletion]()
    //
    @Published var geocodedResults = [MKLocalSearchCompletion]()
    var completer: MKLocalSearchCompleter

    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
    }

    func searchQueryChanged(query: String) {
        completer.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
//        for result in completer.results {
//            self.geocode(result)
//        }

    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print(error.localizedDescription)
    }

//    func geocode(_ result: MKLocalSearchCompletion) {
//        print(result.title)
//        CLGeocoder().geocodeAddressString(result.title) { (placemarks, error) in
//            guard let _ = placemarks?.first else {
//                print("not valid placemark, \(result.title)")
//                return
//            }
//            self.searchResults.append(result)
//            print("ADDED")
//        }
//    }
}
