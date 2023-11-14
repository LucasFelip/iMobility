import Foundation
import FirebaseFirestore
import FirebaseStorage

class PersistenceOccurrenceManager {
    static let shared = PersistenceOccurrenceManager()
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var changesDetected: Bool = false
    
    private init() {}
    
    func loadOccurrencesPaginated(startAfterDocument: DocumentSnapshot? = nil, limit: Int = 10, completion: @escaping ([Occurrence], DocumentSnapshot?) -> Void) {
        var query: Query = db.collection("occurrences").order(by: "dateRegister").limit(to: limit)

        if let lastDocument = startAfterDocument {
            query = query.start(afterDocument: lastDocument)
        }

        query.getDocuments { (querySnapshot, error) in
            var occurrences: [Occurrence] = []
            var lastDocument: DocumentSnapshot?

            if let error = error {
                print("Error getting occurrences: \(error)")
                completion([], nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    completion([], nil)
                    return
                }

                for document in documents {
                    let data = document.data()
                    
                    let id = Int(data["id"] as? Int ?? 0)
                    let userId = data["userId"] as? Int ?? 0
                    let latitude = data["latitude"] as? Double ?? 0.0
                    let longitude = data["longitude"] as? Double ?? 0.0
                    let imageURLString = data["imageURL"] as? String ?? ""
                    let imageURL = URL(string: imageURLString)
                    let positiveRate = data["positiveRate"] as? Double ?? 0.0
                    let negativeRate = data["negativeRate"] as? Double ?? 0.0
                    let typeRawValue = data["type"] as? String ?? ""
                    let type = TypeOccurrence(rawValue: typeRawValue) ?? .buracoVia
                    let dateRegister = data["dateRegister"] as? Date ?? Date()
                    let city = data["city"] as? String ?? ""
                    let state = data["state"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let neighborhood = data["neighborhood"] as? String ?? ""

                    let user = User(id: userId, name: "", email: "", password: "", imagePerfil: Data(), points: 0.0)
                    
                    if let imageURL = imageURL {
                        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                            if let imageData = data {
                                let occurrence = Occurrence(id: id, user: user, latitude: latitude, longitude: longitude, image: imageData, positiveRate: positiveRate, negativeRate: negativeRate, type: type, dateRegister: dateRegister, city: city, state: state, country: country, neighborhood: neighborhood)
                                occurrences.append(occurrence)
                            }
                            completion(occurrences, lastDocument)
                        }.resume()
                    } else {
                        let occurrence = Occurrence(id: id, user: user, latitude: latitude, longitude: longitude, image: Data(), positiveRate: positiveRate, negativeRate: negativeRate, type: type, dateRegister: dateRegister, city: city, state: state, country: country, neighborhood: neighborhood)
                        occurrences.append(occurrence)
                        completion(occurrences, lastDocument)
                    }
                }

                lastDocument = documents.last
                completion(occurrences, lastDocument)
            }
        }
    }
    
    func saveOccurrence(occurrence: Occurrence) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("imagesOccurrences/\(occurrence.id).jpg")
        
        imageRef.putData(occurrence.imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Error uploading image: \(String(describing: error))")
                return
            }
    
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(String(describing: error))")
                    return
                }
                
                let docRef = self.db.collection("occurrences").document(String(occurrence.id))
                docRef.setData([
                    "id": occurrence.id,
                    "userId": occurrence.userId,
                    "latitude": occurrence.latitude,
                    "longitude": occurrence.longitude,
                    "imageURL": downloadURL.absoluteString,
                    "positiveRate": occurrence.positiveRate,
                    "negativeRate": occurrence.negativeRate,
                    "type": occurrence.type.rawValue,
                    "dateRegister": occurrence.dateRegister,
                    "city": occurrence.city,
                    "state": occurrence.state,
                    "country": occurrence.country,
                    "neighborhood": occurrence.neighborhood
                ])
            }
        }
    }

    func loadOccurrences(completion: @escaping ([Occurrence]) -> Void) {
        var occurrences = [Occurrence]()

        db.collection("occurrences").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting occurrences: \(error)")
                completion([])
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    let data = document.data()

                    let id = Int(data["id"] as? Int ?? 0)
                    let userId = data["userId"] as? Int ?? 0
                    let latitude = data["latitude"] as? Double ?? 0.0
                    let longitude = data["longitude"] as? Double ?? 0.0
                    let imageURLString = data["imageURL"] as? String ?? ""
                    let imageURL = URL(string: imageURLString)
                    let positiveRate = data["positiveRate"] as? Double ?? 0.0
                    let negativeRate = data["negativeRate"] as? Double ?? 0.0
                    let typeRawValue = data["type"] as? String ?? ""
                    let type = TypeOccurrence(rawValue: typeRawValue) ?? .buracoVia
                    let dateRegister = data["dateRegister"] as? Date ?? Date()
                    let city = data["city"] as? String ?? ""
                    let state = data["state"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let neighborhood = data["neighborhood"] as? String ?? ""

                    let user = User(id: userId, name: "", email: "", password: "", imagePerfil: Data(), points: 0.0)
                    
                    if let imageURL = imageURL {
                        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                            if let imageData = data {
                                let occurrence = Occurrence(id: id, user: user, latitude: latitude, longitude: longitude, image: imageData, positiveRate: positiveRate, negativeRate: negativeRate, type: type, dateRegister: dateRegister, city: city, state: state, country: country, neighborhood: neighborhood)
                                occurrences.append(occurrence)
                            }
                            completion(occurrences)
                        }.resume()
                    } else {
                        let occurrence = Occurrence(id: id, user: user, latitude: latitude, longitude: longitude, image: Data(), positiveRate: positiveRate, negativeRate: negativeRate, type: type, dateRegister: dateRegister, city: city, state: state, country: country, neighborhood: neighborhood)
                        occurrences.append(occurrence)
                        completion(occurrences)
                    }
                }
            } else {
                completion([])
            }
        }
    }

    func updateOccurrence(updatedOccurrence: Occurrence) {
        let docRef = db.collection("occurrences").document(String(updatedOccurrence.id))
        docRef.updateData([
            "positiveRate": updatedOccurrence.positiveRate,
            "negativeRate": updatedOccurrence.negativeRate,
        ])
    }
    
    func startObservingChanges() {
        listener = db.collection("occurrences").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot: \(String(describing: error)) ?? Unknown error)")
                return
            }

            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    self.changesDetected = true
                }
                if diff.type == .modified {
                    self.changesDetected = true
                }
                if diff.type == .removed {
                    self.changesDetected = true
                }
            }
        }
    }

    func stopObservingChanges() {
        listener?.remove()
    }
        
    func changesOccurred() -> Bool {
        startObservingChanges()
        return changesDetected
    }
    
    func resetChanges() {
        changesDetected = false
        stopObservingChanges()
    }
}
