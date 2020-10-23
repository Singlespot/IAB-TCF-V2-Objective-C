//
//  SPTIabTCFModelV1.h
//  SPTProximityKit
//
//  Created by Quentin Beaudouin on 04/06/2020.
//  Copyright © 2020 Alexandre Fortoul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTIabPublisherRestriction.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPTIabTCFModel : NSObject

//v1 & v2
@property (assign, nonatomic) NSInteger version;
@property (retain, nonatomic) NSDate * created;
@property (retain, nonatomic) NSDate * lastUpdated;
@property (assign, nonatomic) NSInteger cmpId;
@property (assign, nonatomic) NSInteger cmpVersion;
@property (assign, nonatomic) NSInteger consentScreen;
@property (retain, nonatomic) NSString * consentCountryCode;
@property (assign, nonatomic) NSInteger vendorListVersion;
@property (retain, nonatomic) NSString * parsedPurposesConsents;
@property (retain, nonatomic) NSString * parsedVendorsConsents;

//v2
@property (retain, nonatomic) NSString * parsedPurposesLegitmateInterest;
@property (retain, nonatomic) NSString * parsedVendorsLegitmateInterest;
@property (assign, nonatomic) NSInteger policyVersion;
@property (assign, nonatomic) BOOL isServiceSpecific;
@property (assign, nonatomic) BOOL useNonStandardStack;
@property (retain, nonatomic) NSString * specialFeatureOptIns;
@property (assign, nonatomic) BOOL purposeOneTreatment;
@property (retain, nonatomic) NSString * publisherCountryCode;
@property (retain, nonatomic) NSArray<SPTIabPublisherRestriction *> * publisherRestrictions;

@property (retain, nonatomic) NSString * parsedDisclosedVendors;
@property (retain, nonatomic) NSString * parsedAllowedVendors;

@property (retain, nonatomic) NSString * publisherTCParsedPurposesConsents;
@property (retain, nonatomic) NSString * publisherTCParsedPurposesLegitmateInterest;
@property (retain, nonatomic) NSString * publisherTCParsedCustomPurposesConsents;
@property (retain, nonatomic) NSString * publisherTCParsedCustomPurposesLegitmateInterest;


- (BOOL)isVendorConsentGivenFor:(int)vendorId
    NS_SWIFT_NAME(isVendorConsentGivenFor(vendorId:));
- (BOOL)isVendorLegitInterestGivenFor:(int)vendorId
    NS_SWIFT_NAME(isVendorLegitInterestGivenFor(vendorId:));
- (BOOL)isPurposeConsentGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPurposeConsentGivenFor(purposeId:));
- (BOOL)isPurposeLegitInterestGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPurposeLegitInterestGivenFor(purposeId:));
- (BOOL)isSpecialFeatureOptedInFor:(int)specialFeatureId
    NS_SWIFT_NAME(isSpecialFeatureOptedInFor(specialFeatureId:));
- (BOOL)isVendorDiscloseFor:(int)vendorId
    NS_SWIFT_NAME(isVendorDiscloseFor(vendorId:));
- (BOOL)isVendorAllowedFor:(int)vendorId
    NS_SWIFT_NAME(isVendorAllowedFor(vendorId:));
- (BOOL)isPublisherPurposeConsentGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPublisherPurposeConsentGivenFor(purposeId:));
- (BOOL)isPublisherPurposeLegitInterestGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPublisherPurposeLegitInterstGivenFor(purposeId:));
- (BOOL)isPublisherCustomPurposeConsentGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPublisherCustomPurposeConsentGivenFor(purposeId:));
- (BOOL)isPublisherCustomPurposeLegitInterestGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPublisherCustomPurposeLegitInterestGivenFor(purposeId:));

- (PublisherRestrictionType)publisherRestrictionTypeForVendor:(int)vendorId forPurpose:(int)purposeId NS_REFINED_FOR_SWIFT;

- (NSDictionary *)asJson;

@end

NS_ASSUME_NONNULL_END
