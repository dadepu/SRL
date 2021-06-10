//
//  CodingTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 09.06.21.
//

import Foundation

import Foundation
import XCTest
@testable import SRL

class CodingTest: XCTestCase {
    
    func testSchedulerEncoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let scheduler = Scheduler()
        
        let schedulerEncoded = try encoder.encode(scheduler)
        let schedulerDecoded = try decoder.decode(Scheduler.self, from: schedulerEncoded)

        print(schedulerDecoded)
    }
}
