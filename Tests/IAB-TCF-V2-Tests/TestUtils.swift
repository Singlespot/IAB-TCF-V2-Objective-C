//
//  TestUtils.swift
//  IAB-TCF-V2-Tests
//
//  Created by Matthew Paletta on 2020-10-22.
//

import XCTest
import Foundation
import IAB_TCF_V2_API

class TestUtils {
    public static func parse(_ consentString: String, version: Int) -> SPTIabTCFModel {
        let model = SPTIabTCFApi().decodeTCString(consentString)
        XCTAssertTrue(model?.version == version)
        XCTAssertNotNil(model)
        return model!
    }

    private static func from2sComplement(_ str: String) -> Int {
        let positive = str.substring(fromIndex: 0).substring(toIndex: 1)
        if positive == "0" {
            let val = str.substring(fromIndex: 1)
            return Int(val, radix: 2)!
        } else if positive == "1" {
            let x = Int8(bitPattern: UInt8(str, radix: 2)!)
            return Int(x)
        } else {
            return 0
        }
    }

    public static func base64FromBitString(_ str: String) -> String {
        var bits = Array<UInt8>()
        for j in 0..<str.count {
            if (j % 8 == 0) {
                let substr = str.substring(fromIndex: j).substring(toIndex: 8)
                let num = TestUtils.from2sComplement(substr)

                bits.append(UInt8(bitPattern: Int8(num)))
                print(substr, num)
            }
        }
        return Data(bytes: bits).base64EncodedString()
    }

    public static func dateFromFormat(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: str)
        return date
    }

}

extension String {

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, self.count) ..< self.count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(self.count, r.lowerBound)),
                                            upper: min(self.count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
