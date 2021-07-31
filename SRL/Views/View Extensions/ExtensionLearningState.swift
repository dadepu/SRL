//
//  ExtensionLearningState.swift
//  SRL
//
//  Created by Daniel Koellgen on 30.07.21.
//

import Foundation

extension LearningState {
    
    var status: String {
        switch (self) {
        case .LEARNING:
            return "Learning"
        case .REVIEW:
            return "Review"
        case .LAPSE:
            return "Lapse"
        }
    }
}
