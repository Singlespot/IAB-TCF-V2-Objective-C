//
//  StringDecoderTests.swift
//  IAB-TCF-V2-Tests
//
//  Created by Matthew Paletta on 2020-10-23.
//

import XCTest
import IAB_TCF_V2_API

class StringDecoderTests: XCTestCase {

    func testCanCreateModelFromParsedString() {
        let string = "COtybn4PA_zT4KjACBENAPCIAEBAAECAAIAAAAAAAAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw"
        XCTAssertNotNil(SPTIabTCFApi.decode(TCString: string))
    }

    func testCanCreateModelOnePartString() {
        let string = "COtybn4PA_zT4KjACBENAPCIAEBAAECAAIAAAAAAAAAA"
        XCTAssertNotNil(SPTIabTCFApi.decode(TCString: string))
    }

//    func testShouldFailIfANonSupportedVersionIsPassed() {
//        let string = Data(bytes: [13]).base64EncodedString()
//        XCTAssertNil(SPTIabTCFApi().decodeTCString(string))
//    }
//
//    func testReadBeyondBuffer() {
//        let string = SPTIabTCFApi().decodeTCString("Bg")
//        XCTAssertNil(string?.created)
//    }
}
