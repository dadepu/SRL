//
//  ScheduleLearningSteps.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct LearningSteps: InputValidation, Codable{
    private static var stringPattern = #"^(\d)+(\s(\d)+)*"#
    private (set) var learningStepsSeconds: [TimeInterval]
    

    private init(stepsSeconds: [TimeInterval]) {
        self.learningStepsSeconds = stepsSeconds
    }
    
    static func makeFromString(stepsMinutes: String) throws -> LearningSteps {
        let feedback = validateLearningSteps(inputSteps: stepsMinutes)
        guard feedback == .OK else {
            throw feedback
        }
        let stepsSeconds: [TimeInterval] = stepsMinutes.split(separator: " ").map { subStr in Double(String(subStr))! * 60 }
        return LearningSteps(stepsSeconds: stepsSeconds)
    }
    
    static func makeFromTimeInterval(stepsSeconds: [TimeInterval]) -> LearningSteps {
        LearningSteps(stepsSeconds: stepsSeconds)
    }
    
    static func validateLearningSteps(inputSteps: String) -> LearningStepsException {
        guard !inputSteps.isEmpty else {
            return LearningStepsException.EMPTY
        }
        guard validateRegEx(input: inputSteps, pattern: {stringPattern}) else {
            return LearningStepsException.INVALID_PATTERN
        }
        return LearningStepsException.OK
    }
}

enum LearningStepsException: Error {
    case OK
    case EMPTY
    case INVALID_PATTERN
}
