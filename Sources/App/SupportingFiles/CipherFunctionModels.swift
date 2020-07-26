//
//  File.swift
//  
//
//  Created by Issey Rollison on 21/7/20.
//

import Foundation
import EnigmaKit


//----------Enigma Cipher----------//

enum RotorModel {
    case I
    case II
    case III
    case IV
    case V
}

struct EnigmaRotorModel {
    let position: Int
    let ring: Int
    let rotorType: Rotor
}

struct EnigmaModel {
    let rotors: [EnigmaRotorModel]
    let plugboard: String
    let reflector: Reflector
}

//----------Replacement Cipher----------//

struct ReplacementModel {
    var orginalString = String()
    var newString = String()
    var caseSensitive = String()
}


//----------Error Models----------//

//----------Caesar Cipher----------//

enum CaesarCipherErrors: Error {
    case shiftIsNegative
    case shiftIsTooHigh
}

//----------Enigma Cipher----------//

enum EnigmaCipherErrors: Error {
    case plugboardIsIncorectNotEven
    case plugboardContainsInvalidCharacters
    case plugboardContainsDuplicateCharacters
}

