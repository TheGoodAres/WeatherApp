import Foundation
import CoreLocation

//get location from latitude and longitute
func getLocFromLatLong(lat: Double, lon: Double) async -> String
{
    var locationString: String
    var placemarks: [CLPlacemark]
    let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)

    let ceo: CLGeocoder = CLGeocoder()

    let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    do {
        placemarks = try await ceo.reverseGeocodeLocation(loc)
        if placemarks.count > 0 {


            if (!placemarks[0].name!.isEmpty) {

                locationString = placemarks[0].name!

            } else {
                locationString = (placemarks[0].locality ?? "No City")
            }

            return locationString
        }
    } catch {
        print("Reverse geodecoe fail: \(error.localizedDescription)")
        locationString = "No City, No Country"

        return locationString
    }

    return "Error getting Location"
}


//location manager used to ask for permission to access user location
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: // Location services are available.
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break

        case .restricted: // Location services currently unavailable.
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            break

        case .notDetermined: // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            authorizationStatus = .notDetermined
            break

        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
