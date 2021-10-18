//
//  main.swift
//  7shifts-TestInterview
//
//  Created by Josue German Hernandez Gonzalez on 17-10-21.
//

import Foundation


/// Constants struct with all values to use in the main class
struct Constants {
    static let delimitarPattern = "//.*$"
    static let newLinePatern = "\n"
    static let defaultDelimiter = ","
    static let delimiterPrefix = "//"
}

/// Custom error exception
struct NegativeError: Error, Equatable {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

class Main {
        
    init(){}
    
    
    /// Method that validates if in an String there is some kind of match bases on a regular expresion
    /// - Parameters:
    ///   - text: value to be validated for a regex
    ///   - pattern: this is the regex
    /// - Returns: a Bool that tells us if a match exist or not
    func useRegex(for text: String, pattern: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let range = NSRange(location: 0, length: text.count)
        let matches = regex.matches(in: text, options: [], range: range)
        return matches.first != nil
    }
    
    
    /// Method that validates if the input data contains a new delimiter
    /// - Parameter data: value with the data to process
    /// - Returns: This method returnw two values:
    ///            - newDelimiter: String with new delimiter. Necessary to process the data
    ///            - newData: String with the new data corresponding to the new delimiter
    func validateDelimiter(for data: String) -> (newDelimiter: String, newData: String) {
        // get the element who containts the possible delimiter value
        let delimiterValue = data.split(separator: "\n")
        
        // validate if delimiterValue complies with the pattern
        if useRegex(for: String(delimiterValue.first!), pattern: Constants.delimitarPattern) {
            var newDelimiter = String(delimiterValue.first!)
            newDelimiter.removeAll(where: { Constants.delimiterPrefix.contains($0) } )
            return (newDelimiter, newDelimiter + delimiterValue.last!)
        } else {
            // default values to return
            return ("","")
        }
    }
    
    
    /// Method that adds up the number of elements received as a string and returns the total of that sum.
    /// - When there is an empty string, 0 is returned.
    /// - When a value inside the array is not a number it is eliminated.
    /// - Parameter number: The numbers in string are separated by a comma
    /// - Returns: An integer representing the result of the sum.
    func Add(_ number: String?) throws -> Int? {
        guard let number = number, !number.isEmpty else { return 0 }
        
        var digits: [String] = []
        var tmp: [String] = []
        
        let result = validateDelimiter(for: number)
        
        if !result.newData.isEmpty {
            digits = result.newData.components(separatedBy: result.newDelimiter.isEmpty ?
                                                Constants.defaultDelimiter : result.newDelimiter)
        } else {
            digits = number.components(separatedBy: result.newDelimiter.isEmpty ?
                                       Constants.defaultDelimiter : result.newDelimiter)
        }
        

        // When the string is like \n1,2,3\n
        for var digit in digits {
            if useRegex(for: digit, pattern: Constants.newLinePatern) {
                digit.removeAll(where: { Constants.newLinePatern.contains($0) })
                tmp.append(digit)
            } else {
                tmp.append(digit)
            }
        }
        digits = tmp
        
        var numbers = digits.compactMap { $0 == "" ? .zero : Int($0) }
        numbers = numbers.compactMap{ $0 > 1000 ? nil : $0 }
        
        
        let negativesNumbers = numbers.compactMap{ $0.signum() == -1 ? $0 : nil }
        if !negativesNumbers.isEmpty {
            throw NegativeError("""
                                Negatives not allowed. \
                                This is the list of numbers that caused the exeption \
                                \(negativesNumbers)
                                """)
        }
        

        return numbers.reduce(0, +)
    }
    
}

// Start here.
let main = Main()
let result1 = try! main.Add("1\n,2\n,XXX")
let result2 = try! main.Add("\n1,2,4")
let result3 = try! main.Add("200000,200000,2000000")

print(result1!)
print(result2!)
print(result3!)


