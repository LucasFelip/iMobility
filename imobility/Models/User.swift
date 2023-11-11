import Foundation

class User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let password: String
    let imagePerfilData: Data
    var points: Double

    init(id: Int, name: String, email: String, password: String, imagePerfil: Data, points: Double) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.imagePerfilData = imagePerfil
        self.points = points
    }
    
    func calculateUserPoints() {
        let positiveRateMultiplier = 15.0
        let negativeRateMultiplier = 5.0
        let reductionFactor = 0.8

        let userScore = positiveRateMultiplier - negativeRateMultiplier

        let reducedScore = userScore * reductionFactor
        
        points += reducedScore
        if points < 0 {
            points = 0
        }
    }
}
