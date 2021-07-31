//
//  LearningStep.swift
//  SRL
//
//  Created by Daniel Koellgen on 28.07.21.
//

import Foundation

struct LearningStep: Codable {
    private (set) var learningIndex: Int
    
    private init(stepIndex: Int) {
        self.learningIndex = stepIndex
    }
    
    static func makeNew() -> LearningStep {
        LearningStep(stepIndex: 0)
    }
    
    static func makeNewUnitTestOnly(index: Int) -> LearningStep {
        LearningStep(stepIndex: index)
    }
    
    func incrementedStep() -> LearningStep {
        LearningStep(stepIndex: self.learningIndex + 1)
    }
}
