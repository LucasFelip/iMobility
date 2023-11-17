import Foundation
import Combine
import MapKit
import FirebaseFirestore

class OccurrenceManager: NSObject, ObservableObject {
    @Published var occurrences: [Occurrence] = []
    private var lastDocumentSnapshot: DocumentSnapshot?
    private var isPaginating = false
    
    override init() {
        super.init()
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
    
    func loadMoreOccurrences() {
        loadTotalOccurrencesDatabasePaginated()
    }
    
    func clearAndReloadOccurrences() {
        self.occurrences = []
        self.lastDocumentSnapshot = nil
        loadTotalOccurrencesDatabase()
    }

    func loadTotalOccurrencesDatabase() {
        PersistenceOccurrenceManager.shared.loadOccurrences { [weak self] newOccurrences in
            DispatchQueue.main.async {
                self?.updateOccurrencesList(with: newOccurrences)
            }
        }
    }

    func updateOccurrencesList(with newOccurrences: [Occurrence]) {
        for newOccurrence in newOccurrences {
            if let index = occurrences.firstIndex(where: { $0.id == newOccurrence.id }) {
                occurrences[index] = newOccurrence
            } else {
                occurrences.append(newOccurrence)
            }
        }
    }
    
    private func loadTotalOccurrencesDatabasePaginated() {
        guard !isPaginating else { return }
        isPaginating = true
        PersistenceOccurrenceManager.shared.loadOccurrencesPaginated(startAfterDocument: lastDocumentSnapshot) { [weak self] (newOccurrences, lastDocument) in
            DispatchQueue.main.async {
                self?.updateOccurrencesList(with: newOccurrences)
                self?.lastDocumentSnapshot = lastDocument
                self?.isPaginating = false
            }
        }
    }
}
