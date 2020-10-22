//
//  DecodeTests.swift
//  IAB-TCF-V2
//
//  Created by Matthew Paletta on 2020-10-22.
//

import XCTest

import IAB_TCF_V2_API

class DecodeTests: XCTestCase {

    func parse(_ consentString: String) -> SPTIabTCFModel {
        let model = SPTIabTCFApi().decodeTCString(consentString)
        XCTAssertTrue(model?.version == 2)
        XCTAssertNotNil(model)
        return model!
    }

    func dateFromFormat(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: str)
        return date
    }

    func testCanConstructTCModelFromBase64String() {
        let model = self.parse("COtybn4PA_zT4KjACBENAPCIAEBAAECAAIAAAAAAAAAA")
        XCTAssertEqual(model.version, 2)
        XCTAssertEqual(model.created, self.dateFromFormat("2020-01-26T17:01:00Z"))
        XCTAssertEqual(model.lastUpdated, self.dateFromFormat("2021-02-02T17:01:00Z"))
        XCTAssertEqual(model.cmpId, 675)
        XCTAssertEqual(model.cmpVersion, 2)
        XCTAssertEqual(model.consentScreen, 1)
        XCTAssertEqual(model.vendorListVersion, 15)
        XCTAssertEqual(model.policyVersion, 2)
        //XCTAssertEqual(model.consentLanguage, "EN")
        XCTAssertEqual(model.publisherCountryCode, "AA")
        XCTAssertFalse(model.isServiceSpecific)
        XCTAssertTrue(model.purposeOneTreatment)
        XCTAssertFalse(model.useNonStandardStack)
    }

    func testConstructConsentsFromBitFields() {
        let model = self.parse("COrEAV4OrXx94ACABBENAHCIAD-AAAAAAACAAxAAAAgAIAwgAgAAAAEAgQAAAAAEAYQAQAAAACAAAABAAA")

        XCTAssertTrue([3, 4, 5, 6, 7, 8, 9].allSatisfy(model.isPurposeConsentGiven(for:)))
        XCTAssertTrue([23, 37, 47, 48, 53, 65, 98].allSatisfy(model.isVendorConsentGiven(for:)))
        XCTAssertTrue([37, 47, 48, 53, 65, 98, 129].allSatisfy(model.isVendorLegitInterestGiven(for:)))
    }

    func testCanParseDisclosedAndAllowedVendors() {
        let model = self.parse("COrEAV4OrXx94ACABBENAHCIAD-AAAAAAACAAxAAAAgAIAwgAgAAAAEAgQAAAAAEAYQAQAAAACAAAABAAA.IBAgAAAgAIAwgAgAAAAEAAAACA.QAagAQAgAIAwgA")
        XCTAssertTrue([12, 23, 37, 47, 48, 53].allSatisfy(model.isVendorAllowed(for:)))
        XCTAssertTrue([23, 37, 47, 48, 53, 65, 98, 129].allSatisfy(model.isVendorDisclose(for:)))
    }

    

}
