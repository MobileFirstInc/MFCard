//
//  CreditCardValidator.swift
//
//  Created by Vitaliy Kuzmenko on 02/06/15.
//  Copyright (c) 2015. All rights reserved.
//
//Fork Branch: https://github.com/RC7770/CreditCardValidator.git
import Foundation

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

open class CreditCardValidator {
    
    open lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object as [String : AnyObject]))
        }
        return types
    }()
    
    public init() { }
    
    /**
     Get card type from string
     
     - parameter string: card number string
     
     - returns: CreditCardValidationType structure
     */
    open func typeFromString(_ string: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbersFromString(string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }
    
    /**
     Validate card number
     
     - parameter string: card number string
     
     - returns: true or false
     */
    open func validateString(_ string: String) -> Bool {
        let numbers = self.onlyNumbersFromString(string)
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        
        let range :Range<String.Index> = numbers.startIndex ..< numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [NSString.EnumerationOptions.reverse, NSString.EnumerationOptions.byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        

        var oddSum = 0, evenSum = 0
        let reversedArray = Array(reversedString)
        let i = 0
        
        for s in reversedArray {
            
            let digit = Int(String(s))!
            
            if i+1 % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
    
    /**
     Validate card number string for type
     
     - parameter string: card number string
     - parameter type:   CreditCardValidationType structure
     
     - returns: true or false
     */
    open func validateString(_ string: String, forType type: CreditCardValidationType) -> Bool {
        return typeFromString(string) == type
    }
    
    open func onlyNumbersFromString(_ string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    fileprivate static let types = [
        [
            "name": "Amex",
            "regex": "^3[47][0-9]{5,}$"
        ],[
            "name": "Electron",
            "regex": "^(4026|417500|4405|4508|4844|4913|4917)\\d+$"
        ], [
            "name": "Visa",
            "regex": "^4[0-9]{6,}$"
        ], [
            "name": "MasterCard",
            "regex": "^5[1-5][0-9]{5,}$"
        ], [
            "name": "Maestro",
            "regex": "^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\\d+$"
        ], [
            "name": "Diners Club",
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        ], [
            "name": "JCB",
            "regex": "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        ], [
            "name": "Discover",
            "regex": "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        ], [
            "name": "UnionPay",
            "regex": "^(62|88)\\d+$"
        ],  [
            "name": "Dankort",
            "regex": "^(5019)\\d+$"
        ],
            [
            "name":  "RuPay",
            "regex": "^(6061|6062|6063|6064|6065|6066|6067|6068|6069|607|608)\\d+$"
        ]
    ]
    
}
