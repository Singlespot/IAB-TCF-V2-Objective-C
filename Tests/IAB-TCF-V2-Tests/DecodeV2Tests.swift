//
//  DecodeTests.swift
//  IAB-TCF-V2
//
//  Created by Matthew Paletta on 2020-10-22.
//

import XCTest
import Foundation

import IAB_TCF_V2_API

class DecodeTests: XCTestCase {
    private func parse(_ consentString: String) -> SPTIabTCFModel {
        return TestUtils.parse(consentString, version: 2)
    }

    func testCanConstructTCModelFromBase64String() {
        let model = self.parse("COtybn4PA_zT4KjACBENAPCIAEBAAECAAIAAAAAAAAAA")
        XCTAssertEqual(model.version, 2)
        XCTAssertEqual(model.created, TestUtils.dateFromFormat("2020-01-26T17:01:00Z"))
        XCTAssertEqual(model.lastUpdated, TestUtils.dateFromFormat("2021-02-02T17:01:00Z"))
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

        XCTAssertTrue([3, 4, 5, 6, 7, 8, 9].allSatisfy(model.isPurposeConsentGivenFor(purposeId:)))
        XCTAssertTrue([23, 37, 47, 48, 53, 65, 98].allSatisfy(model.isVendorConsentGivenFor(vendorId:)))
        XCTAssertTrue([37, 47, 48, 53, 65, 98, 129].allSatisfy(model.isVendorLegitInterestGivenFor(vendorId:)))
    }

    func testCanParseDisclosedAndAllowedVendors() {
        let model = self.parse("COrEAV4OrXx94ACABBENAHCIAD-AAAAAAACAAxAAAAgAIAwgAgAAAAEAgQAAAAAEAYQAQAAAACAAAABAAA.IBAgAAAgAIAwgAgAAAAEAAAACA.QAagAQAgAIAwgA")
        XCTAssertTrue([12, 23, 37, 47, 48, 53].allSatisfy(model.isVendorAllowedFor(vendorId:)))
        XCTAssertTrue([23, 37, 47, 48, 53, 65, 98, 129].allSatisfy(model.isVendorDiscloseFor(vendorId:)))
    }

    func testCanParseAllParts() {
        let model = self.parse("COrEAV4OrXx94ACABBENAHCIAD-AAAAAAACAAxAAAAgAIAwgAgAAAAEAgQAAAAAEAYQAQAAAACAAAABAAA.IBAgAAAgAIAwgAgAAAAEAAAACA.QAagAQAgAIAwgA.cAAAAAAAITg=")
        XCTAssertEqual(model.publisherTCParsedPurposesConsents, "100000000000000000000000")
    }

    func testCanParseRangeEncodedVendorLegitimateInterests() {
        let model = self.parse("COv__-wOv__-wC2AAAENAPCgAAAAAAAAAAAAA_wAQA_gEBABAEAAAA")
        XCTAssertTrue(model.isVendorLegitInterestGivenFor(vendorId: 128))
    }

    func testPublisherRestrinctions() {
        let bitString = "0000100011101011100"
            + "1000000000000001010"
            + "0000001110101110010"
            + "0000000000000101000"
            + "0000110011111000000"
            + "0000000000000000100"
            + "0011010000000011110"
            + "0001000000000000000"
            + "0000000000000000000"
            + "0000000000000000000"
            + "0000000000000000000"
            + "0000000000000000000"
            + "0000000000000000000"
            + "000000000011"
            + // NumPubRestrictions (1)
            "000001"
            + // PurposeId
            "01"
            + // restriction type Require Consent
            "000000000000"
            + "000010"
            + // PurposeId
            "00"
            + // restriction type Not Allowed
            "000000000000"
            + "000011"
            + // PurposeId
            "10"
            + // restriction REQUIRE_LEGITIMATE_INTEREST
            "000000000000"
            + "0"; // padding

        let base64String = TestUtils.base64FromBitString(bitString)
        let model = self.parse(base64String)
        let actual = model.publisherRestrictions
        let expected = [
            SPTIabPublisherRestriction(1, restrictionType: .Restriction_RequireConsent, vendorIds: [], parsedVendors: nil),
            SPTIabPublisherRestriction(2, restrictionType: .Restriction_NotAllowedByPublisher, vendorIds: [], parsedVendors: nil),
            SPTIabPublisherRestriction(3, restrictionType: .Restriction_RequireLegitimateInterest, vendorIds: [], parsedVendors: nil)
        ]
//        XCTAssertEqual(actual, expected)

        XCTAssertGreaterThan(actual.capacity, 0)
        XCTAssertEqual(actual[0].purposeId, 1)
        XCTAssertEqual(actual[0].restrictionType, .Restriction_RequireConsent)
        XCTAssertEqual(actual[0].vendorsIds.count, 0)
    }

    func testPublisherPurposes() {
        let publisherPurposes = "011"
            + // segment type
            "100000000000000000000000"
            + // PubPurposesConsent
            "000000000000000000000001"
            + // PubPurposesLITransparency
            "000010"
            + // number of custom purposes
            "01"
            + // CustomPurposesConsent
            "11"
            + // CustomPurposesLITransparency
            "000"; // just padding
        let base64CoreString = "COtybn4PA_zT4KjACBENAPCIAEBAAECAAIAAAAAAAAAA" + "." + TestUtils.base64FromBitString(publisherPurposes)
        let model = self.parse(base64CoreString)

        XCTAssertTrue(model.isPublisherPurposeConsentGivenFor(purposeId: 1))
        XCTAssertTrue(model.isPublisherPurposeLegitInterstGivenFor(purposeId: 24))
        XCTAssertTrue(model.isPublisherCustomPurposeConsentGivenFor(purposeId:  2))
        XCTAssertTrue([1, 2].allSatisfy(model.isPublisherCustomPurposeLegitInterestGivenFor(purposeId:)))
    }

    func testDefaultSegmentType() {
        let publisherPurposes = "00000000"; // segment type
        let base64CoreString = "COtybn4PA_zT4KjACBENAPCIAEBAAECAAIAAAAAAAAAA" + "." + TestUtils.base64FromBitString(publisherPurposes)

        let model = self.parse(base64CoreString)
        XCTAssertTrue(model.publisherTCParsedCustomPurposesConsents.isEmpty)
    }

    func testRange() {
        let base64CoreString2Range = "COwBOpCOwBOpCLqAAAENAPCAAAAAAAAAAAAAFfwAYFfAV-BVkAGBVYFWAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw"
        let base64CoreString1Range = "COwBOpCOwBOpCLqAAAENAPCAAAAAAAAAAAAAFfwAQFfgUbABAUaAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw"
        let model2 = self.parse(base64CoreString2Range)
        XCTAssertTrue([702, 703].allSatisfy(model2.isVendorConsentGivenFor(vendorId:)))

        let model1 = self.parse(base64CoreString1Range)
        XCTAssertTrue([703].allSatisfy(model1.isVendorConsentGivenFor(vendorId:)))
    }

    func testPurposesConsent() {
        let consent = "COwxsONOwxsONKpAAAENAdCAAMAAAAAAAAAAAAAAAAAA"
        let model = self.parse(consent)

        XCTAssertTrue([1, 2].allSatisfy(model.isPurposeConsentGivenFor(purposeId:)))
    }

    func testHashCodeEquals() {
        let consent = "COwBOpCOwBOpCLqAAAENAPCAAAAAAAAAAAAAFfwAQFfgUbABAUaAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw"
        let model1 = self.parse(consent)
        let model2 = self.parse(consent)

        XCTAssertEqual(model1.hashValue, model2.hashValue)
    }

    func testHashCodeNotEquals() {
        let consent1 = "COwxsONOwxsONKpAAAENAdCAAMAAAAAAAAAAAAAAAAAA"
        let model1 = self.parse(consent1)

        let consent2 = "COwBOpCOwBOpCLqAAAENAPCAAAAAAAAAAAAAFfwAQFfgUbABAUaAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw"
        let model2 = self.parse(consent2)

        XCTAssertNotEqual(model1.hashValue, model2.hashValue)
    }

    func testHashCodeSegments() {
        let consent1 = "COwBOpCOwBOpCLqAAAENAPCAAAAAAAAAAAAAFfwAQFfgUbABAUaAAA"
        let model1 = self.parse(consent1)

        let consent2 = "COwBOpCOwBOpCLqAAAENAPCAAAAAAAAAAAAAFfwAQFfgUbABAUaAAA.IFoEUQQgAIQwgIwQABAEAAAAOIAACAIAAAAQAIAgEAACEAAAAAgAQBAAAAAAAGBAAgAAAAAAAFAAECAAAgAAQARAEQAAAAAJAAIAAgAAAYQEAAAQmAgBC3ZAYzUw"
        let model2 = self.parse(consent2)

        XCTAssertNotEqual(model1.hashValue, model2.hashValue)
    }
}
