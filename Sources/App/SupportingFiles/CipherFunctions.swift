//
//  File.swift
//
//
//  Created by Issey Rollison on 24/6/20.
//

import Foundation
import EnigmaKit


class CipherFunctions {
    //----------Caesar Cipher----------//
    
    static func caeser(input: String, shift: Int, encode: Bool) -> String {
        var output: String = String()
        input.forEach() { character in
            var characterOut: Character = "A"
            let currentLetterValue = character.asciiValue
            if let currentLetterValue = currentLetterValue {
                let oldChar = character
                let newValue = encode ? currentLetterValue + UInt8(shift) : currentLetterValue - UInt8(shift)
              
                characterOut = Character(UnicodeScalar(newValue))
                
                if !((currentLetterValue >= 65 && currentLetterValue <= 90) || (currentLetterValue >= 97 && currentLetterValue <= 122)) {
                    characterOut = character
                } else if oldChar.isUppercase && (currentLetterValue + UInt8(shift) > UInt8(90)) && encode {
                    let difference = UInt8(shift) - (UInt8(90) - currentLetterValue) - 1
                    characterOut = (Character(UnicodeScalar(65 + difference)))
                } else if oldChar.isUppercase && (currentLetterValue - UInt8(shift) < UInt8(65)) && !encode {
                    let difference = UInt8(shift) - (currentLetterValue - UInt8(65)) - 1
                    characterOut = (Character(UnicodeScalar(90 - difference)))
                } else if oldChar.isLowercase && (currentLetterValue + UInt8(shift) > UInt8(122)) && encode {
                    let difference = UInt8(shift) - (UInt8(122) - currentLetterValue) - 1
                    characterOut = (Character(UnicodeScalar(97 + difference)))
                } else if oldChar.isLowercase && (currentLetterValue - UInt8(shift) < UInt8(97)) && !encode {
                    let difference = UInt8(shift) - (currentLetterValue - UInt8(97)) - 1
                    characterOut = (Character(UnicodeScalar(122 - difference)))
                } 
            }
            output.append(characterOut)
        }
        return output
    }

    
    //----------Reverse Cipher----------//
    static func reverseCipher(input: String) -> String {
        String(input.reversed())
    }
    
    
    //----------Repacement Cipher----------//
   
    static func replaceCipher(input: String, using replacement: ReplacementModel) -> String {
        if replacement.caseSensitive == "sensitive" {
            return input.replacingOccurrences(of: replacement.orginalString, with: replacement.newString)
        } else {
            return input.replacingOccurrences(of: replacement.orginalString, with: replacement.newString, options: .caseInsensitive)
        }
    }
    
    
    
    //----------Enigma Cipher----------//


    static func enigmaCipher(input: String, settings: EnigmaModel) -> String {
        var plugboard = Plugboard()
        
        var rotor1 = settings.rotors[0].rotorType
        rotor1.setting = settings.rotors[0].ring
        rotor1.position = settings.rotors[0].position
        
        var rotor2 = settings.rotors[1].rotorType
        rotor2.setting = settings.rotors[1].ring
        rotor2.position = settings.rotors[1].position

        var rotor3 = settings.rotors[2].rotorType
        rotor3.setting = settings.rotors[2].ring
        rotor3.position = settings.rotors[2].position
        
        var plugboardLetters = settings.plugboard.uppercased()
        plugboardLetters.removeAll(where: { $0 == " " })
        
        var count = 0
        var tempLetters: (Character, Character) = (" ", " ")
        
        plugboardLetters.forEach() { i in
            if count == 0 {
                tempLetters.0 = i
            }
            
            if count == 1 {
                tempLetters.1 = i
            }
            count += 1
            if count == 2 {
                count = 0
                plugboard.add((tempLetters.0, tempLetters.1))
            }
        }
        
//        for i in 0...plugboardLetters.count - 1 {
//            tempLetters.append(Character(extendedGraphemeClusterLiteral: plugboardLetters[i]))
//            if i.isMultiple(of: 2) {
//                plugboard.add((Character(temporaryPair[0]), Character(temporaryPair[1])))
//            }
//        }
        
        print(plugboard)
        
        let enigma = Enigma(reflector: settings.reflector, rotors: [rotor1, rotor2, rotor3], plugboard: plugboard)
        
        return enigma.encode(input.uppercased())
    }
    
//    static func enigmaCipher1() -> String {
//        var plugboard = Plugboard()
//        
//        var rotor1 = Rotor.I
//        rotor1.setting = 1
//        rotor1.position = 1
//        
//        var rotor2 = Rotor.I
//        rotor2.setting = 1
//        rotor2.position = 1
//
//        var rotor3 = Rotor.I
//        rotor3.setting = 1
//        rotor3.position = 1
//        
//        let enigma = Enigma(reflector: Reflector.B, rotors: [rotor1, rotor2, rotor3], plugboard: plugboard)
//        
//        return enigma.encode("test")
//        
//    }
    
    static func translateRotorData(stringVersion: String) -> Rotor {
        switch stringVersion {
        case "I":
            return Rotor.I

        case "II":
            return Rotor.II

        case "III":
            return Rotor.III

        case "IV":
            return Rotor.I

        case "V":
            return Rotor.I

        default:
            return Rotor.I

        }
    }
    
    static func translateReflectorData(stringVersion: String) -> Reflector {
        switch stringVersion {
        case "a":
            return Reflector.A
        case "b":
            return Reflector.B
        case "c":
            return Reflector.C
        default:
            return Reflector.A
        }
    }
}




//class CipherFunctions {
//    static func caeserCipher(character: inout Character, shift: Int) {
//        let currentLetterValue = character.asciiValue
//        if let currentLetterValue = currentLetterValue {
//            let oldChar = character
//            let newValue = currentLetterValue + UInt8(shift)
//            character = Character(UnicodeScalar(newValue))
//
//            if oldChar.isUppercase && (currentLetterValue + UInt8(shift) > UInt8(90)) {
//                print("Greater than")
//                let difference = UInt8(shift) - (UInt8(90) - currentLetterValue) - 1
//                character = Character(UnicodeScalar(65 + difference))
//            }
//            if oldChar.isLowercase && (currentLetterValue + UInt8(shift) > UInt8(122)) {
//                print("Greater than")
//                let difference = UInt8(shift) - (UInt8(122) - currentLetterValue) - 1
//                character = Character(UnicodeScalar(97 + difference))
//            }
//        }
//    }
//
//    static func replaceCipher(replace originalChar: Character, from input: inout String, with replacedChar: Character) {
//        input = input.replacingOccurrences(of: String(originalChar), with: String(replacedChar))
//    }
//
//    static func reversedCipher(_ input: inout String) {
//        input = String(input.reversed())
//    }
//
//    static func engimaCipher(input: inout String, model: EnigmaCipherModel) {
//        let enigma = Enigma()
//        input = enigma.encode(input)
//    }
//
//}
//
//
//caeser(input: "Issey", shift: 8, encode: true) { (output) in
//    print(output)
//}
//
//
//func caeser(input: String, shift: Int, encode: Bool, completion: @escaping (String) -> Void) {
//    var output: String = String()
//    input.forEach() { character in
//        var characterOut: Character = "A"
//        let currentLetterValue = character.asciiValue
//        if let currentLetterValue = currentLetterValue {
//            let oldChar = character
//            let newValue = encode ? currentLetterValue + UInt8(shift) : currentLetterValue - UInt8(shift)
//
//            characterOut = UnicodeScalar(newValue)
//
//            if oldChar.isUppercase && (currentLetterValue + UInt8(shift) > UInt8(90)) {
//                let difference = UInt8(shift) - (UInt8(90) - currentLetterValue) - 1
//                characterOut = (Character(UnicodeScalar(65 + difference)))
//
//            } else if oldChar.isUppercase && (currentLetterValue - UInt8(shift) < UInt8(67)) && !encode {
//                let difference = UInt8(shift) - (currentLetterValue - UInt8(67)) - 1
//                characterOut = (Character(UnicodeScalar(90 - difference)))
//            }
//
//            if oldChar.isLowercase && (currentLetterValue + UInt8(shift) > UInt8(122)) {
//                let difference = UInt8(shift) - (UInt8(122) - currentLetterValue) - 1
//                characterOut = (Character(UnicodeScalar(97 + difference)))
//            } else if oldChar.isLowercase && (currentLetterValue - UInt8(shift) < UInt8(97)) && !encode {
//                // Problem lies within this if statement
//                print("Running")
//                let difference = UInt8(shift) - (currentLetterValue - UInt8(97)) - 1
//                characterOut = (Character(UnicodeScalar(122 - difference)))
//            }
//        }
//        output.append(characterOut)
//    }
//    completion(output)
//}
//
//
////func reverseCipher(input: String, completion: @escaping)

