//
//  ScheduleLapseSteps.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct LapseSteps: InputValidation, Codable {
    private static var stringPattern = #"^(\d)*(\s(\d)+)*"#
    private (set) var lapseStepsSeconds: [TimeInterval]
    
//    var asString: String {
//        get {
//            lapseStepsSeconds
//                .map({(step: Double) in
//                        String(format: "%.0f", step)
//                })
//                .reduce("", {x, y in
//                        x + (x.isEmpty ? y : " " + y)
//                })
//        }
//    }
    
    
    private init(stepsSeconds: [TimeInterval]) {
        self.lapseStepsSeconds = stepsSeconds
    }
    
    static func makeFromString(stepsMinutes: String) throws -> LapseSteps {
        let feedback = validateLapseSteps(inputSteps: stepsMinutes)
        guard feedback == .OK else {
            throw feedback
        }
        let stepsSeconds: [TimeInterval] = !stepsMinutes.isEmpty ? stepsMinutes.split(separator: " ").map { subStr in Double(String(subStr))! * 60 } : []
        return LapseSteps(stepsSeconds: stepsSeconds)
    }
    
    static func makeFromTimeInterval(stepsSeconds: [TimeInterval]) -> LapseSteps {
        LapseSteps(stepsSeconds: stepsSeconds)
    }
    
    static func validateLapseSteps(inputSteps: String) -> LapseStepsException {
        guard !inputSteps.isEmpty else {
            return LapseStepsException.OK
        }
        guard validateRegEx(input: inputSteps, pattern: {stringPattern}) else {
            return LapseStepsException.INVALID_PATTERN
        }
        return LapseStepsException.OK
    }
    
    func toStringMinutes() -> String {
        lapseStepsSeconds.map( { (step: Double) in
            String(format: "%.0f", step / 60)
        })
        .reduce("", {initial, step in
            initial + (initial.isEmpty ? step : " " + step)
        })
    }
}

enum LapseStepsException: Error {
    case OK
    case INVALID_PATTERN
}
