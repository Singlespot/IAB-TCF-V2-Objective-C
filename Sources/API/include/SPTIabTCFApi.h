//
//  SPTIabTCFApi.h
//  SPTProximityKit
//
//  Created by Quentin Beaudouin on 14/06/2020.
//  Copyright © 2020 Alexandre Fortoul. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPTIabTCFv1StorageProtocol.h"
#import "SPTIabTCFv2StorageProtocol.h"
#import "SPTIabTCStringParser.h"

/**
 Object that provides the interface for storing and retrieving GDPR-related information
 */
@interface SPTIabTCFApi : NSObject

/**
 Set to true if consents of IAB v1 are considered deprecated or non valid (default @c true)
 */
@property (nonatomic, assign) BOOL ignoreV1;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefs
    NS_SWIFT_NAME(initWith(userDefaults:));

+ (SPTIabTCFModel *)decodeTCString:(NSString *)tcString
    NS_SWIFT_NAME(decode(TCString:));
/**
 The consent string passed as a websafe base64-encoded string.
 */
@property (nonatomic, retain) NSString *consentString;

- (NSInteger)tcfVersionForTCString:(NSString*)string
    NS_SWIFT_NAME(tcfVersionFor(TCString:));

//******************************************************************
#pragma mark - V1 Specific
//******************************************************************

/**
 Enum that indicates    'SubjectToGDPR_Unknown'- value -1, unset.
                        'SubjectToGDPR_No' – value 0, not subject to GDPR
                        'SubjectToGDPR_Yes' – value 1, subject to GDPR,
 */
@property (nonatomic, assign) SubjectToGDPR subjectToGDPR;

/**
 Integer ID of the IAB CMP
 */
@property (nonatomic, assign) NSInteger cmpID;


/**
 Boolean that indicates if a CMP implementing the iAB specification is present in the application
 */
@property (nonatomic, assign) BOOL cmpPresent;


//******************************************************************
#pragma mark - V1 & V2
//******************************************************************

/**
 String that contains the consent information for all vendors.
 */
@property (nonatomic, retain, readonly) NSString *parsedVendorConsents;

/**
 String that contains the consent information for all purposes.
 */
@property (nonatomic, retain, readonly) NSString *parsedPurposeConsents;

//- (void)setParsedVendorConsents:(NSString *)parsedVendorConsents forV1:(BOOL)forV1;
//- (void)setParsedPurposeConsents:(NSString *)parsedPurposeConsents forV1:(BOOL)forV1;

/**
Returns true if user consent has been given to vendor for the specified consent string
*/
- (BOOL)isVendorConsentGivenFor:(int)vendorId inConsentString:(NSString*)string;

/**
 Returns true if user consent has been given to vendor
 */
- (BOOL)isVendorConsentGivenFor:(int)vendorId
    NS_SWIFT_NAME(isVendorConsentGivenFor(vendorId:));

/**
 Returns true if user consent has been given for purpose for the specified consent string
 */
- (BOOL)isPurposeConsentGivenFor:(int)purposeId inConsentString:(NSString*)string;

/**
 Returns true if user consent has been given for purpose
 */
- (BOOL)isPurposeConsentGivenFor:(int)purposeId
    NS_SWIFT_NAME(isPurposeConsentGivenFor(purposeId:));

//******************************************************************
#pragma mark - V2 Specific
//******************************************************************

/**
 Enum that indicates    'SubjectToGDPR_Unknown'- value -1, unset.
                        'SubjectToGDPR_No' – value 0, not subject to GDPR
                        'SubjectToGDPR_Yes' – value 1, subject to GDPR,
 */
@property (assign, nonatomic) NSInteger cmpSdkId;
@property (assign, nonatomic) NSInteger cmpSdkVersion;
@property (assign, nonatomic) NSInteger policyVersion;
@property (assign, nonatomic) GdprApplies gdprApplies;
@property (retain, nonatomic) NSString * publisherCountryCode;
@property (assign, nonatomic) BOOL purposeOneTreatment;
@property (assign, nonatomic) BOOL useNonStandardStack;
@property (assign, nonatomic) BOOL isServiceSpecific;

- (BOOL)isVendorLegitimateInterestGivenFor:(int)vendorId
    NS_SWIFT_NAME(isVendorLegitimateInterestGivenFor(vendorId:));
- (BOOL)isPurposeLegitimateInterestGivenFor:(int)vendorId
    NS_SWIFT_NAME(isPurposeLegitimateInterestGivenFor(vendorId:));

- (PublisherRestrictionType)publisherRestrictionTypeForVendor:(int)vendorId forPurpose:(int)purposeId;

- (BOOL)isSpecialFeatureOptedInFor:(int)specialFeatureId
    NS_SWIFT_NAME(isSpecialFeatureOptedInFor(specialFeatureId:));

- (BOOL)isVendorDiscloseFor:(int)vendorId
    NS_SWIFT_NAME(isVendorDiscloseFor(vendorId:));
- (BOOL)isVendorAllowedFor:(int)vendorId
    NS_SWIFT_NAME(isVendorAllowedFor(vendorId:));
- (BOOL)isPublisherPurposeConsentGivenFor:(int)vendorId
    NS_SWIFT_NAME(isPublisherPurposeConsentGivenFor(vendorId:));
- (BOOL)isPublisherPurposeLegitimateInterestGivenFor:(int)vendorId
    NS_SWIFT_NAME(isPublisherPublisherLegitimateInterestsGivenFor(vendorId:));
- (BOOL)isPublisherCustomPurposeConsentGivenFor:(int)vendorId
    NS_SWIFT_NAME(isPublisherCustomPurposeConsentGivenFor(vendorId:));
- (BOOL)isPublisherCustomPurposeLegitimateInterestGivenFor:(int)vendorId
    NS_SWIFT_NAME(isPublisherCustomPurposeLegitimateInterestGivenFor(vendorId:));

/**
 The object that provides all the GDPR-related data for further processing.
 The default data storage is NSUserDefaults.
 */
@property (nonatomic, retain) id<SPTIabTCFv1StorageProtocol> v1DataStorage;
@property (nonatomic, retain) id<SPTIabTCFv2StorageProtocol> v2DataStorage;

@end

