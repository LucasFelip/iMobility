import Foundation

enum TypeOccurrence: String, Codable, CaseIterable {
    case buracoVia = "Buraco na Rua"
    case faltaSinalizacao = "Falta de Sinalização"
    case buracoCalcada = "Buraco na Calçada"
    case obstrucaoVia = "Obstrução na Via"
    case faltaIluminacao = "Falta de Iluminação"
    case faltaSaneamento = "Falta de Saneamento"
    case alagamento = "Alagamento"
    case quedasArvores = "Queda de Árvores"
    case semaforoDefeituoso = "Semáforo Defeituoso"
    case congestionamento = "Congestionamento"
    case bloqueioRua = "Bloqueio de Rua"
    case pistaEscorregadia = "Pista Escorregadia"
    case estradaDanificada = "Estrada Danificada"
    case faixaPedestresApagadas = "Faixas de Pedestres Apagadas"
    
    var description: String {
        return self.rawValue
    }
    
    static var allOptions: [TypeOccurrence] {
        return self.allCases
    }
}
