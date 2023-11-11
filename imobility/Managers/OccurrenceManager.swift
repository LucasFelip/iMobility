import Foundation
import Combine
import MapKit

class OccurrenceManager: NSObject, ObservableObject {
    @Published var occurrences: [Occurrence] = []
    
    override init() {
        super.init()
        self.occurrences = loadOccurrencesDataFromMemory()
    }
    
    func registerOccurrenceUser(currentUser: User, mapLocation: MapLocation, type: TypeOccurrence, image: Data){
        let uniqueID = Int(Date().timeIntervalSince1970)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: mapLocation.latitude, longitude: mapLocation.longitude)) { placemarks, error in
            if let error = error {
                print("\n Geocoding error: \(error)")
            } else if let placemark = placemarks?.first {
                let neighborhhod = placemark.subLocality ?? "Unknown neighborhhod"
                let city = placemark.locality ?? "Unknown city"
                let state = placemark.administrativeArea ?? "Unknown state"
                let country = placemark.country ?? "Unknown country"
                
                let newOccurrence = Occurrence(id: uniqueID, user: currentUser, latitude: mapLocation.latitude, longitude: mapLocation.longitude, image: image, positiveRate: 0.0, negativeRate: 0.0, type: type, dateRegister: Date(), city: city, state: state, country: country, neighborhood: neighborhhod)
                
                PersistenceOccurrenceManager.shared.saveOccurrence(occurrence: newOccurrence)
            }
        }
    }
    
    func updateOccurrence(updateOccurrence: Occurrence) {
        UserManager().updateUserPoints()
        PersistenceOccurrenceManager.shared.updateOccurrence(updatedOccurrence: updateOccurrence)
    }
    
    func loadTotalOccurrence() {
        loadTotalOccurrencesDatabase()
    }

    private func loadTotalOccurrencesDatabase() {
        removeOccurrenceFromMemory()
        PersistenceOccurrenceManager.shared.loadOccurrences { [self] occurrence in
            DispatchQueue.main.async { [self] in
                self.occurrences = occurrence
                
                if !occurrence.isEmpty {
                    saveOccurrenceFromMemory(occurrence)
                }
            }
        }
    }
    
    private func saveOccurrenceFromMemory(_ occurrences: [Occurrence]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(occurrences) {
            UserDefaults.standard.set(encoded, forKey: "occurrenceData")
        }
    }
    
    private func removeOccurrenceFromMemory() {
        if UserDefaults.standard.data(forKey: "occurrenceData") != nil {
            UserDefaults.standard.removeObject(forKey: "occurrenceData")
        }
    }
    
    func loadOccurrencesDataFromMemory() -> [Occurrence] {
        if let occurrenceData = UserDefaults.standard.data(forKey: "occurrenceData") {
            let decoder = JSONDecoder()
            if let occurrences = try? decoder.decode([Occurrence].self, from: occurrenceData) {
                return occurrences
            }
        }
        return []
    }
}
