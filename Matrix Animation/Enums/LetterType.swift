//
//  LetterType.swift
//  Matrix Animation
//
//  Created by GE-Developer
//

// MARK: - LetterType
enum LetterType {
    case englishCapitalizedAlphabet
    case georgian
    case eas256
    case binary
    case decimal
    case currency
    case custom(String)
    
    var get: [Character] {
        switch self {
        case .englishCapitalizedAlphabet: return Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        case .georgian: return Array("აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ")
        case .eas256: return Array("!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
        case .binary: return Array("01")
        case .decimal: return Array("0123456789")
        case .currency: return Array("$€£¥₽₿₾")
        case .custom(let symbols): return Array(symbols)
        }
    }
}
