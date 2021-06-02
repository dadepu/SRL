//
//  Schedulable.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

protocol Schedulable {
    var settings: SchedulerSettings { get set }
    var learningState: LearningState { get }
    var lastReviewDate: Date { get }
    var nextReviewDate: Date { get }
    var reviewCount: Int { get }
    var currentReviewInterval: TimeInterval { get }
    
    var remainingReviewInterval: TimeInterval { get }
    var isDueForReview: Bool { get }
    var cardIsNew: Bool { get }
    
    func processedReviewAction(as: ReviewAction) -> Scheduler
}
