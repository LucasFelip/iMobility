import Foundation
import MapKit

class Occurrence: Identifiable, Codable {
    var id: Int
    var userId: Int
    var latitude: Double
    var longitude: Double
    var imageData: Data
    var positiveRate: Double
    var negativeRate: Double
    let type: TypeOccurrence
    var city: String
    var state: String
    var country: String
    var neighborhood: String
    let dateRegister: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(id: Int, user: User, latitude: Double, longitude: Double, image: Data, positiveRate: Double, negativeRate: Double, type: TypeOccurrence, dateRegister: Date, city: String, state: String, country: String, neighborhood: String) {
        self.id = id
        self.userId = user.id
        self.latitude = latitude
        self.longitude = longitude
        self.imageData = image
        self.positiveRate = positiveRate
        self.negativeRate = negativeRate
        self.type = type
        self.dateRegister = dateRegister
        self.city = city
        self.country = country
        self.state = state
        self.neighborhood = neighborhood
    }
    
    func positiveRateToggle() {
        positiveRate += 1
    }
    
    func negativeRateToggle() {
        negativeRate += 1
    }
}
