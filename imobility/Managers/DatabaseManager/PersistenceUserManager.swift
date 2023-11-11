import Foundation
import FirebaseFirestore
import FirebaseStorage

class PersistenceUserManager {
    static let shared = PersistenceUserManager()
    private let db = Firestore.firestore()

    private init() {}

    func saveUser(user: User) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let docRef = self.db.collection("users").document(String(user.id))
        
        if !user.imagePerfilData.isEmpty {
            let imageRef = storageRef.child("imagesUserPerfil/\(user.id).jpg")
            
            imageRef.putData(user.imagePerfilData, metadata: nil) { metadata, error in
                guard metadata != nil else {
                    print("Error uploading image: \(String(describing: error))")
                    return
                }
                
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("Error getting download URL: \(String(describing: error))")
                        return
                    }
                    
                    docRef.setData([
                        "id": user.id,
                        "name": user.name,
                        "email": user.email,
                        "password": user.password,
                        "imagePerfilDataURL": downloadURL.absoluteString,
                        "points": user.points
                    ])
                }
            }
        } else {
            docRef.setData([
                "id": user.id,
                "name": user.name,
                "email": user.email,
                "password": user.password,
                "imagePerfilDataURL": "",
                "points": user.points
            ])
        }
    }

    func loadTopUsers(completion: @escaping ([User]) -> Void) {
        var topUsers = [User]()

        db.collection("users")
            .order(by: "points", descending: true)
            .order(by: "name")
            .limit(to: 25)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting top users: \(error)")
                    completion([])
                } else if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()

                        let name = data["name"] as? String ?? ""
                        let points = data["points"] as? Double ?? 0.0

                        let user = User(id: 0, name: name, email: "", password: "", imagePerfil: Data(), points: points)
                        topUsers.append(user)
                    }
                    completion(topUsers)
                } else {
                    completion([])
                }
            }
    }

    func getUserByEmailAndPassword(email: String, password: String, completion: @escaping (User?) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    let data = document.data()

                    guard let storedPassword = data["password"] as? String, storedPassword == password else {
                        completion(nil)
                        return
                    }
                    let id = Int(data["id"] as? Int ?? 0)
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let imageURL = data["imagePerfilDataURL"] as? String ?? ""
                    let imagePerfilData = URL(string: imageURL)
                    let points = data["points"] as? Double ?? 0.0
                    
                    if let imagePerfilData = imagePerfilData {
                        URLSession.shared.dataTask(with: imagePerfilData) { (data, response, error) in
                            if let imageData = data {
                                let user = User(id: id, name: name, email: email, password: password, imagePerfil: imageData, points: points)
                                completion(user)
                            } else {
                                let user = User(id: id, name: name, email: email, password: password, imagePerfil: Data(), points: points)
                                completion(user)
                            }
                        }.resume()
                        return
                    } else {
                        let user = User(id: id, name: name, email: email, password: password, imagePerfil: Data(), points: points)
                        completion(user)
                        return
                    }
                }
                completion(nil)
            }
        }
    }

    func updateUser(updatedUser: User) {
        let docRef = db.collection("users").document(String(updatedUser.id))
        
        if !updatedUser.imagePerfilData.isEmpty {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child("imagesUserPerfil/\(updatedUser.id).jpg")
            
            imageRef.putData(updatedUser.imagePerfilData, metadata: nil) { metadata, error in
                guard metadata != nil else {
                    print("Error uploading image: \(String(describing: error))")
                    return
                }
                
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("Error getting download URL: \(String(describing: error))")
                        return
                    }
                    
                    docRef.updateData([
                        "name": updatedUser.name,
                        "email": updatedUser.email,
                        "password": updatedUser.password,
                        "imagePerfilDataURL": downloadURL.absoluteString,
                        "points": updatedUser.points
                    ])
                }
            }
        } else {
            docRef.updateData([
                "name": updatedUser.name,
                "email": updatedUser.email,
                "password": updatedUser.password,
                "imagePerfilDataURL": "",
                "points": updatedUser.points
            ])
        }
    }
    
    func getUserByID(id: Int, completion: @escaping (User?) -> Void) {
        db.collection("users").document(String(id)).getDocument { (document, error) in
            if let error = error {
                print("Error getting user by ID: \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                let data = document.data()
                
                let id = Int(data!["id"] as? Int ?? 0)
                let name = data!["name"] as? String ?? ""
                let email = data!["email"] as? String ?? ""
                let imageURL = data!["imagePerfilDataURL"] as? String ?? ""
                let imagePerfilData = URL(string: imageURL)
                let password = data!["password"] as? String ?? ""
                let points = data!["points"] as? Double ?? 0.0
                
                if let imagePerfilData = imagePerfilData {
                    URLSession.shared.dataTask(with: imagePerfilData) { (data, response, error) in
                        if let imageData = data {
                            let user = User(id: id, name: name, email: email, password: password, imagePerfil: imageData, points: points)
                            completion(user)
                        } else {
                            let user = User(id: id, name: name, email: email, password: password, imagePerfil: Data(), points: points)
                            completion(user)
                        }
                    }.resume()
                    return
                } else {
                    let user = User(id: id, name: name, email: email, password: password, imagePerfil: Data(), points: points)
                    completion(user)
                    return
                }
            } else {
                completion(nil)
            }
        }
    }
}
