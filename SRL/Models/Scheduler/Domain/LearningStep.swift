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
        return LearningStep(stepIndex: 0)
    }
    
    func incrementedStep() -> LearningStep {
        return LearningStep(stepIndex: self.learningIndex + 1)
    }
}
