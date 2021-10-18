//
//  _shifts_Test.swift
//  7shifts-Test
//
//  Created by Josue German Hernandez Gonzalez on 17-10-21.
//

import XCTest
@testable import _shifts_TestInterview

class MainTest: XCTestCase {
    
    var main: Main!
    
    override func setUp() {
        self.main = Main()
    }
    
    override func tearDown() {
        self.main = nil
    }
    
    func testInputOnlyInts() {
        let input = "1,2,5"
        let expected = 8
        XCTAssertEqual(try! self.main.Add(input), expected)
    }
    
    func testInputIntsAndEmptyStrings() {
        let input = "1,2,5,,,,"
        let expected = 8
        XCTAssertEqual(try! self.main.Add(input), expected)
    }
    
    func testInputIntsAndCharacters() {
        let input = "o,9,9,2,0,1,c,hi"
        let expected = 21
        XCTAssertEqual(try self.main.Add(input), expected)
    }
    
    func testInputOnlyEmptyStrings() {
        let input = ",,,,,,,,,,"
        XCTAssertEqual(try self.main.Add(input), 0)
    }
    
    func testAllValuesIntoInput() {
        let input = "2,43,900,j,hi,,,,t,1"
        let expected = 946
        XCTAssertEqual(try self.main.Add(input), expected)
    }
    
    func testEmptyInputString() {
        let input = ""
        XCTAssertEqual(try self.main.Add(input), 0)
    }
    
    func testNilInputString() {
        XCTAssertEqual(try self.main.Add(nil), 0)
    }
    
    func testInputWithNewLine() {
        let input = "1\n,\n2\n,\n3"
        let expected = 6
        XCTAssertEqual(try self.main.Add(input), expected)
    }
    
    func testNegativeNumbers() {
        let input = "-2,-4,-9"
        let result = try? self.main.Add(input)
        XCTAssertNil(result)
    }
    
    func testThrowErrorWithNegativeValues() {
        let input = "-2,4,9"
        XCTAssertThrowsError(try self.main.Add(input), "Negatives values not allowed") { error in
            XCTAssertEqual(error as? NegativeError,
                           NegativeError("Negatives not allowed. This is the list of numbers that caused the exeption [-2]"))
        }
        
    }
    
    func testNumbersLargeThan1000Ignored() {
        let input = "2000,2000,1000,90000"
        let expected = 1000
        XCTAssertEqual(try self.main.Add(input), expected)
    }
    
    func testNumbersEqualThan1000() {
        let input = "1000,1000,1000,1001,1001,,,"
        let expected = 3000
        XCTAssertEqual(try self.main.Add(input), expected)
    }
    
    func testNewDelimiter_$_inString() {
        let input = "//$\n1$2$3"
        let expected = 6
        XCTAssertEqual(try self.main.Add(input), expected)
    }
    
    func testNewDelimiter_inString() {
        let input = "//@\n2@3@8"
        let expected = 13
        XCTAssertEqual(try self.main.Add(input), expected)
    }

}
