//
//  File.swift
//  
//
//  Created by Issey Rollison on 23/6/20.
//

import Foundation
import Vapor

class Ciphers {
    /// Ciphers Available
    /// - Enigma
    /// 
}

// Supports the enigma model 1
// Cipher will support the UKW A
//enum Rotor: Int, Codable {
//    case I
//    case II
//    case III
//    case IV
//    case V
//}
//
//struct EnigmaRotorModel: Codable {
//    let possition: Int
//    let ring: Int
//    let rotorType: Rotor
//}
//
//struct EnigmaCipherModel: Codable {
//    let rotors: [EnigmaRotorModel]
//    let plugboard: String
//}
//

class PublicData {
    static var ciphersAvailable = ["Caesar Cihpher", "Replace Cipher", "Reverse Cipher", "Enigma Machine"]
}
