//
//  SchedulableItem.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

protocol SchedulableItem {
    var schedule: Schedulable { get }
    
    func scheduled(with schedule: Schedulable) -> Card
}
