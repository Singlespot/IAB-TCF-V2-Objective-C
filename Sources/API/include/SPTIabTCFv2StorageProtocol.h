//
//  CMPDataStorageProtocol.h
//  GDPR
//

#import <Foundation/Foundation.h>
#import "SPTIabTCFv2Types.h"

@protocol SPTIabTCFv2StorageProtocol
@required

@property (nonatomic, retain) NSUserDefaults *userDefaults;

@property (assign, nonatomic) NSInteger cmpSdkId;
@property (assign, nonatomic) NSInteger cmpSdkVersion;
@property (assign, nonatomic) NSInteger policyVersion;
@property (assign, nonatomic) GdprApplies gdprApplies;
@property (retain, nonatomic) NSString * publisherCountryCode;
@property (assign, nonatomic) BOOL purposeOneTreatment;
@property (assign, nonatomic) BOOL useNonStandardStack;
@property (assign, nonatomic) BOOL isServiceSpecific;

@property (retain, nonatomic) NSString * tcString;

@property (retain, nonatomic) NSString * parsedVendorsConsents;
@property (retain, nonatomic) NSString * parsedVendorsLegitmateInterest;
@property (retain, nonatomic) NSString * parsedPurposesConsents;
@property (retain, nonatomic) NSString * parsedPurposesLegitmateInterest;

@property (retain, nonatomic) NSString * specialFeatureOptIns;

@property (retain, nonatomic) NSString * publisherTCParsedPurposesConsents;
@property (retain, nonatomic) NSString * publisherTCParsedPurposesLegitmateInterest;
@property (retain, nonatomic) NSString * publisherTCParsedCustomPurposesConsents;
@property (retain, nonatomic) NSString * publisherTCParsedCustomPurposesLegitmateInterest;


- (NSString *)publisherRestrictionsForPurposeId:(NSInteger)purposeId
    NS_SWIFT_NAME(publisherRestrictionsFor(purposeId:));
- (void)setPublisherRestrictions:(NSString *)publisherRestriction ForPurposeId:(NSInteger)purposeId NS_REFINED_FOR_SWIFT;

@end
