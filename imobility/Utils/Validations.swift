import Foundation
import CommonCrypto

func isValidName(_ name: String) -> Bool {
    if name.isEmpty {
        return false
    }

    let nameCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ \u{2019}")
    let invalidCharacterSet = name.unicodeScalars.first { !nameCharacterSet.contains($0) }
    if invalidCharacterSet != nil {
        return false
    }

//    let offensiveWords = ["?"]
//    for word in offensiveWords {
//        if name.localizedCaseInsensitiveContains(word) {
//            return false
//        }
//    }

    return true
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    let isValidFormat = emailPredicate.evaluate(with: email)
    
    if isValidFormat {
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            let range = NSRange(location: 0, length: email.utf16.count)
            if let match = detector.firstMatch(in: email, options: [], range: range) {
                return match.range.length == email.utf16.count
            }
        }
    }
    
    return false
}


func isValidPassword(_ password: String) -> Bool {
    if password.count < 8 {
        return false
    }
    
    let uppercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
    let lowercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
    let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*()-_=+\\[\\]{};:'\"<>,.?/~`]+.*")
    
    if !uppercaseLetterPredicate.evaluate(with: password) ||
       !lowercaseLetterPredicate.evaluate(with: password) ||
       !specialCharacterPredicate.evaluate(with: password) {
        return false
    }
    
    return true
}

func isValidUser(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
    guard let hashedPassword = encryptPassword(password) else {
        completion(false)
        return
    }

    PersistenceUserManager.shared.getUserByEmailAndPassword(email: email, password: hashedPassword) { (user) in
        completion(user != nil)
    }
}

func encryptPassword(_ password: String) -> String? {
    guard let data = password.data(using: .utf8) else {
        return nil
    }

    var hashedData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    _ = hashedData.withUnsafeMutableBytes { hashedBytes in
        data.withUnsafeBytes { passwordBytes in
            CC_SHA256(passwordBytes, CC_LONG(data.count), hashedBytes.bindMemory(to: UInt8.self).baseAddress)
        }
    }

    let hashedString = hashedData.map { String(format: "%02hhx", $0) }.joined()
    return hashedString
}
