import MapKit

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var country: String = ""
    @Published var state: String = ""
    @Published var city: String = ""
    @Published var neighborhhod: String = ""
        
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 0, longitude: -0),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
        
    override init() {
        super.init()
            
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
        
    func setup() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationDescription() {
        let geocoder = CLGeocoder()
        let center = self.region.center
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("\n Geocoding error: \(error)")
            } else if let placemark = placemarks?.first {
                self.neighborhhod = placemark.subLocality ?? "Unknown neighborhhod"
                self.city = placemark.locality ?? "Unknown city"
                self.state = placemark.administrativeArea ?? "Unknown state"
                self.country = placemark.country ?? "Unknown country"
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
    }
}
