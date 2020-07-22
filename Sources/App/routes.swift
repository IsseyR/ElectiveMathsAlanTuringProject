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
        
        let output = CipherFunctions.caeser(input: data.textInput, shift: data.caesarShift, encode: data.codeDirectionSelection == "encode" ? true : false)
        
        return req.view.render("CipherOutputView", [
            "cipherOut" : output
        ])
    }
    
    app.post("reverseOutput") { req -> EventLoopFuture<View> in
        let data = try req.content.decode(ReverseCipherOutputModel.self)
        print(data.textInput)
        
        let output = CipherFunctions.reverseCipher(input: data.textInput)
        
        return req.view.render("CipherOutputView", [
            "cipherOut" : output
        ])
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
        
        let output = CipherFunctions.enigmaCipher(
            input: data.textInput,
            settings: EnigmaModel(rotors: [EnigmaRotorModel(position: data.rotor1Position, ring: data.rotor1Ring, rotorType: rotor1),
            EnigmaRotorModel(position: data.rotor2Position, ring: data.rotor2Ring, rotorType: rotor2),
            EnigmaRotorModel(position: data.rotor2Position, ring: data.rotor2Ring, rotorType: rotor3)],
            plugboard: data.plugboard, reflector: reflector))
        
        return req.view.render("CipherOutputView", [
            "cipherOut" : output
        ])
    }
}
