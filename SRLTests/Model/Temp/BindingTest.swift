//
//  BindingTest.swift
//  SRLTests
//
//  Created by Daniel Koellgen on 29.05.21.
//

import Foundation
import XCTest
import Combine
@testable import SRL

class BindingTest: XCTestCase {
    
    func testBinding() throws {
        
        class xDeck: ObservableObject {
            @Published private (set) var intArray: Array<Int> = [1,2,3]
            
            func addNumber(_ num: Int) {
                intArray.append(num)
            }
            
            func createQueue(_ fac: ((Published<[Int]>.Publisher) -> xQueue)) ->xQueue {
                fac($intArray)
            }
        }
        
        class xQueue {
            private (set) var cancelPrint: AnyCancellable?
            private (set) var arraySum = {(x: Array<Int>) -> Int in x.reduce(0, {(a: Int, b:Int) -> Int in a + b})}
            
            init(intArr: Published<[Int]>.Publisher) {
                cancelPrint = intArr.sink { intArr in self.printArraySum(arr: intArr) }
            }
            
            private func printArraySum(arr: Array<Int>) {
                print("Queue: \(arraySum(arr))")
            }
        }
        
        let queueBuilder = { (xArr: Published<[Int]>.Publisher) -> xQueue in xQueue(intArr: xArr) }
        
        let deck = xDeck()
        let queue = deck.createQueue(queueBuilder)
        
        deck.addNumber(5)
    }
}
