import Vapor
import Leaf
import EnigmaKit

struct CaesarOutputModel: Content {
    var caesarShift: Int
    var textInput: String
    var codeDirectionSelection: String
}

struct ReverseCipherOutputModel: Content {
    var textInput: String
}

struct ReplacementCipherModel: Content {
    var textInput: String
    var oldString: String
    var newString: String
    var caseSensitive: String?
}

struct EnigmaCipherModel: Content {
    var textInput: String
    
    var rotor1Position: Int
    var rotor1Ring: Int
    var rotor1Num: String
    
    var rotor2Position: Int
    var rotor2Ring: Int
    var rotor2Num: String
    
    var rotor3Position: Int
    var rotor3Ring: Int
    var rotor3Num: String
    
    var plugboard: String
    var reflector: String
}


func routes(_ app: Application) throws {
    
    app.get("home") { req in
        req.view.render("HomeView")
    }
    
    app.get("caesarCipher") { req in
        req.view.render("CaesarCipherView")
    }
    
    app.get("reverseCipher") { req in
        req.view.render("ReverseCipherView")
    }
    
    app.get("replaceCipher") { req in
        req.view.render("ReplaceCipherView")
    }
    
    app.get("enigmaCipher") { req in
        req.view.render("EnigmaCipherView")
    }
    
    app.get("turingmachine") { req in
        req.view.render("TuringMachineView")
    }
    
    app.get("cipherSelection") { req in
        req.view.render("CipherSelectionView")
    }
    
    app.post("caesarOutput") { req -> EventLoopFuture<View> in
        let data = try req.content.decode(CaesarOutputModel.self)
            print(data.caesarShift)
            print(data.textInput)
            print(data.codeDirectionSelection)
        do {
            let output = try CipherFunctions.caeser(input: data.textInput, shift: data.caesarShift, encode: data.codeDirectionSelection == "encode" ? true : false)
            
            return req.view.render("CipherOutputView", [
                "cipherOut" : output
            ])
        } catch CaesarCipherErrors.shiftIsNegative {
            print("🔴 NEGATIVE CAESAR SHIFT ERROR: \(CaesarCipherErrors.shiftIsNegative) 🔴")
            return req.view.render("ErrorView", [
                "errorOut" : "There was an error. This is most likely due to the shift being negative. Make sure it is a positive number and resubmit."
            ])
        } catch CaesarCipherErrors.shiftIsTooHigh {
            print("🔴 SHIFT TOO HIGH CAESAR ERROR: \(CaesarCipherErrors.shiftIsTooHigh) 🔴")
            return req.view.render("ErrorView", [
                "errorOut" : "There was an error. This is most likely due to the shift being too high. Make sure the shift + the ASCII value of each letter is 52 or less. In general there is no need to go above 26 as it just loops around back to 0 beyond that."
            ])
        } catch {
            print("🔴 UNKNOWN CAESAR ERROR 🔴")
            return req.view.render("ErrorView", [
                "errorOut" : "There was an unknown error. Please try using diffrent shift values and inputs."
            ])
        }
    }
    
    app.post("reverseOutput") { req -> EventLoopFuture<View> in
        let data = try req.content.decode(ReverseCipherOutputModel.self)
        print(data.textInput)
        
        do {
            let output = try CipherFunctions.reverseCipher(input: data.textInput)
            
            return req.view.render("CipherOutputView", [
                "cipherOut" : output
            ])
        } catch {
            print("🔴 UNKNOWN REVERSE ERROR 🔴")
            return req.view.render("ErrorView", [
                "errorOut" : "There was an unknown error. Please try using a different input"
            ])
        }
    }
    
    app.post("replaceOutput") { req -> EventLoopFuture<View> in
        let data = try req.content.decode(ReplacementCipherModel.self)
        print(data.textInput)
        print(data.oldString)
        print(data.newString)
        print(data.caseSensitive ?? "insensitive")
        
        let output = CipherFunctions.replaceCipher(input: data.textInput, using: ReplacementModel(orginalString: data.oldString, newString: data.newString, caseSensitive: data.caseSensitive ?? "insensitive"))
        
        return req.view.render("CipherOutputView", [
            "cipherOut" : output
        ])
    }
    
    app.post("enigmaOutput") { req ->  EventLoopFuture<View> in
        let data = try req.content.decode(EnigmaCipherModel.self)
        print(data.textInput)
        print(data.rotor1Position)
        print(data.rotor1Ring)
        print(data.rotor1Num)
        print(data.rotor2Position)
        print(data.rotor2Ring)
        print(data.rotor2Num)
        print(data.rotor3Position)
        print(data.rotor3Ring)
        print(data.rotor3Num)
        
        print(data.plugboard)
        print(data.reflector)
        
        let rotor1 = CipherFunctions.translateRotorData(stringVersion: data.rotor1Num)
        let rotor2 = CipherFunctions.translateRotorData(stringVersion: data.rotor1Num)
        let rotor3 = CipherFunctions.translateRotorData(stringVersion: data.rotor1Num)
        
        let reflector = CipherFunctions.translateReflectorData(stringVersion: data.reflector)
        do {
            let output = try CipherFunctions.enigmaCipher(
                input: data.textInput,
                settings: EnigmaModel(
                    rotors: [
                    EnigmaRotorModel(position: data.rotor1Position, ring: data.rotor1Ring, rotorType: rotor1),
                    EnigmaRotorModel(position: data.rotor2Position, ring: data.rotor2Ring, rotorType: rotor2),
                    EnigmaRotorModel(position: data.rotor2Position, ring: data.rotor2Ring, rotorType: rotor3)
                    ],
                    plugboard: data.plugboard, reflector: reflector))
            
            return req.view.render("CipherOutputView", [
                "cipherOut" : output
            ])
        } catch EnigmaCipherErrors.plugboardIsIncorectNotEven {
            print("🟠 PLUGBOARD NOT EVEN WARNING: \(EnigmaCipherErrors.plugboardIsIncorectNotEven) 🟠")
            return req.view.render("WarningView", [
                "warningOut" : "The plugboard was filled out incorrectly. This could effect the accuracy of the output. Make sure there are spaces between groups of two characters (a - z or A - Z)."
            ])
        } catch EnigmaCipherErrors.plugboardContainsInvalidCharacters {
            print("🟠 PLUGBOARD INVALID CHARACTERS WARNING: \(EnigmaCipherErrors.plugboardContainsInvalidCharacters) 🟠")
            return req.view.render("WarningView", [
                "warningOut" : "The plugboard was filled out incorrectly. Chracters that are not from a - z or A - Z were used. Remove them to ensure accuracy of the output."
            ])
        } catch EnigmaCipherErrors.plugboardContainsDuplicateCharacters {
            print("🟠 PLUGBOARD DUPLICATE CHARACTERS WARNING: \(EnigmaCipherErrors.plugboardContainsDuplicateCharacters) 🟠")
            return req.view.render("WarningView", [
                "warningOut" : "The plugboard contains duplicate characters. Make sure not to use characters more than once to ensure accuracy of the output."
            ])
        }
    }
}
