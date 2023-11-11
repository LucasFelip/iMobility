import SwiftUI
import Combine

class UserManager: NSObject, ObservableObject {
    @Published var totalUsers: [User] = []
    @Published var currentUser: User?
    @Published var topTotalUsers: [User] = []
    
    override init() {
        super.init()
        self.loadCurrentUserIfNeeded()
    }
    
    func sortAndLimitUsers() {
        PersistenceUserManager.shared.loadTopUsers { topUsers in
            self.topTotalUsers = topUsers
        }
    }
    
    func registerUser(name: String, email: String, password: String) {
        let uniqueID = Int(Date().timeIntervalSince1970)
        
        guard let (hashedPassword) = encryptPassword(password) else {
            return
        }
        
        let newUser = User(id: uniqueID, name: name, email: email, password: hashedPassword, imagePerfil: Data(), points: 0.0)
        
        PersistenceUserManager.shared.saveUser(user: newUser)
    }
    
    func updateUser(updateUser: User) {
        PersistenceUserManager.shared.updateUser(updatedUser: updateUser)
        
        PersistenceUserManager.shared.getUserByID(id: updateUser.id) { user in
            if let updatedUser = user {
                self.removeUserFromMemory()
                self.saveUserInMemory(updateUser)
                self.currentUser = updateUser
            }
        }
    }
    
    func updateUserPoints() {
        if let currentUser = currentUser {
            currentUser.calculateUserPoints()
            updateUser(updateUser: currentUser)
        }
    }
    
    func acessUser(email: String, password: String) {
        guard let (hashedPassword) = encryptPassword(password) else {
            return
        }

        PersistenceUserManager.shared.getUserByEmailAndPassword(email: email, password: hashedPassword) { (user) in
            if let user = user {
                self.currentUser = user
                self.saveUserInMemory(user)
            }
        }
    }

    func disconnectUser() {
        if currentUser != nil {
            currentUser = nil
            removeUserFromMemory()
        }
    }
    
    func loadCurrentUserIfNeeded() {
        loadUserDataFromMemory()
    }
    
    private func saveUserInMemory(_ user: User) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedData, forKey: "currentUserData")
        }
    }

    private func removeUserFromMemory() {
        UserDefaults.standard.removeObject(forKey: "currentUserData")
    }

    private func loadUserDataFromMemory() {
        if let userData = UserDefaults.standard.data(forKey: "currentUserData") {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: userData) {
                currentUser = user
            }
        }
    }
}
