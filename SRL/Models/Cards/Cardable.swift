//
//  Cardable.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation

protocol Cardable: SchedulableItem {
    var id: UUID { get }
    var dateCreated: Date { get }
    var dateLastModified: Date { get }
    var schedule: Schedulable { get }
}
